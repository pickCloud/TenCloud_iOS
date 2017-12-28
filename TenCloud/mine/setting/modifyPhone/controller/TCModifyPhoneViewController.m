//
//  TCModifyPhoneViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyPhoneViewController.h"
#import "VHLNavigation.h"
#import "GetCaptchaButton.h"
#import "TCSpacingTextField.h"
#import "TCGetCaptchaRequest.h"
#import "TCRegisterRequest.h"
#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
#import "TCTabBarController.h"
#import "TCSuccessResultViewController.h"
#import "TCResetPhoneRequest.h"

@interface TCModifyPhoneViewController ()
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneNumberField;
@property (nonatomic, weak) IBOutlet    UITextField         *captchaField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    GetCaptchaButton    *captchaButton;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onGetCaptchaButton:(id)sender;
- (IBAction) onRegisterButton:(id)sender;
@end

@implementation TCModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
    //[self vhl_setNavBarHidden:NO];
    //[self vhl_setNavBarTintColor:THEME_TINT_COLOR];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"输入新的手机号码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _phoneNumberField.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *captchaPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"输入验证码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _captchaField.attributedPlaceholder = captchaPlaceHolderStr;
    NSAttributedString *pwdPlaceHolderStr1 = [[NSAttributedString alloc] initWithString:@"输入密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _passwordField.attributedPlaceholder = pwdPlaceHolderStr1;
    
    _phoneNumberField.firstSpacingPosition = 3;
    _phoneNumberField.secondSpacingPosition = 8;
    _phoneNumberField.maxLength = 11;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    [_phoneNumberField resignFirstResponder];
    [_captchaField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (IBAction) onGetCaptchaButton:(id)sender
{
    NSLog(@"on get captcha button");
    if (_phoneNumberField.plainPhoneNum.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号" toView:nil];
        return;
    }
    
    if (_captchaButton.fetchState == FetchCaptchaStateNone ||
        _captchaButton.fetchState == FetchCaptchaStateRefetch)
    {
        [_captchaButton setFetchState:FetchCaptchaStateCountdown];
        TCGetCaptchaRequest *request = [[TCGetCaptchaRequest alloc] initWithPhoneNumber:_phoneNumberField.plainPhoneNum];
        __weak __typeof(self) weakSelf = self;
        [request startWithSuccess:^(NSString *message) {
            [MBProgressHUD showSuccess:@"短信验证码已发送，请注意查收" toView:nil];
            [weakSelf.captchaField becomeFirstResponder];
        } failure:^(NSString *message, NSInteger errorCode) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }
}

- (IBAction) onRegisterButton:(id)sender
{
    NSLog(@"on register button");
    if (_phoneNumberField.plainPhoneNum.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号" toView:nil];
        return;
    }
    if (_captchaField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return;
    }
    if (_passwordField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入密码" toView:nil];
        return;
    }
    [_phoneNumberField resignFirstResponder];
    [_captchaField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
    __weak __typeof(self) weakSelf = self;
    [MMProgressHUD showWithStatus:@"修改手机号中"];
    TCResetPhoneRequest *request = [[TCResetPhoneRequest alloc] initWithPhoneNumber:_phoneNumberField.plainPhoneNum password:_passwordField.text captcha:_captchaField.text];
    [request startWithSuccess:^(NSString *token) {
        [[TCLocalAccount shared] setToken:token];
        [[TCLocalAccount shared] save];
        [MMProgressHUD dismiss];
        
        TCSuccessResultViewController *successVC = [[TCSuccessResultViewController alloc] initWithTitle:@"修改成功" desc:@"6小时内可撤销修改"];
        successVC.finishBlock = ^(UIViewController *viewController) {
            [viewController.navigationController popViewControllerAnimated:YES];
        };
        NSArray *viewControllers = self.navigationController.viewControllers;
        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
        [newVCS removeLastObject];
        [newVCS addObject:successVC];
        [weakSelf.navigationController setViewControllers:newVCS];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
    
    /*
    TCRegisterRequest *request = [[TCRegisterRequest alloc] initWithPhoneNumber:_phoneNumberField.plainPhoneNum password:_passwordField.text captcha:_captchaField.text];
    [request startWithSuccess:^(NSString *token) {
        [[TCLocalAccount shared] setToken:token];
        TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
        [request startWithSuccess:^(TCUser *user) {
            user.token = token;
            [[TCLocalAccount shared] loginSuccess:user];
            TCTabBarController *tabBarController = [TCTabBarController new];
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
            [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
        } failure:^(NSString *message) {
            NSLog(@"msg:%@",message);
            [MMProgressHUD dismissWithError:message];
        }];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
     */
    
}

@end
