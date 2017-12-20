//
//  TCForgetPasswordViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCForgetPasswordViewController.h"
#import "VHLNavigation.h"
#import "GetCaptchaButton.h"
#import "TCSpacingTextField.h"
#import "TCGetCaptchaRequest.h"
#import "TCRegisterRequest.h"
#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
#import "TCTabBarController.h"
#import "TCResetPasswordRequest.h"

@interface TCForgetPasswordViewController ()
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneNumberField;
@property (nonatomic, weak) IBOutlet    UITextField         *captchaField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *password2Field;
@property (nonatomic, weak) IBOutlet    GetCaptchaButton    *captchaButton;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onGetCaptchaButton:(id)sender;
- (IBAction) onRegisterButton:(id)sender;
@end

@implementation TCForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self vhl_setNavBarHidden:NO];
    [self vhl_setNavBarTintColor:THEME_TINT_COLOR];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入手机号码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _phoneNumberField.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *captchaPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入验证码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _captchaField.attributedPlaceholder = captchaPlaceHolderStr;
    NSAttributedString *pwdPlaceHolderStr1 = [[NSAttributedString alloc] initWithString:@"请输入新密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _passwordField.attributedPlaceholder = pwdPlaceHolderStr1;
    NSAttributedString *pwdPlaceHolderStr2 = [[NSAttributedString alloc] initWithString:@"请再输入一遍"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _password2Field.attributedPlaceholder = pwdPlaceHolderStr2;
    
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
    NSLog(@"on tap blank area");
    [_phoneNumberField resignFirstResponder];
    [_captchaField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_password2Field resignFirstResponder];
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
    if (_password2Field.text.length == 0)
    {
        [MBProgressHUD showError:@"请确认密码" toView:nil];
        return;
    }
    if (![_passwordField.text isEqualToString:_password2Field.text])
    {
        [MBProgressHUD showError:@"密码不一致" toView:nil];
        return;
    }
    [_phoneNumberField resignFirstResponder];
    [_captchaField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_password2Field resignFirstResponder];
    
    [MMProgressHUD showWithStatus:@"找回密码中"];
    TCResetPasswordRequest *request = [[TCResetPasswordRequest alloc] initWithPhoneNumber:_phoneNumberField.plainPhoneNum password:_passwordField.text captcha:_captchaField.text];
    [request startWithSuccess:^(NSString *token) {
        [[TCLocalAccount shared] setToken:token];
        TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
        [request startWithSuccess:^(TCUser *user) {
            user.token = token;
            [[TCLocalAccount shared] loginSuccess:user];
            TCTabBarController *tabBarController = [TCTabBarController new];
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
            [MMProgressHUD dismissWithSuccess:@"成功找回密码" title:nil afterDelay:1.32];
        } failure:^(NSString *message) {
            NSLog(@"msg:%@",message);
            [MMProgressHUD dismissWithError:@"找回失败"];
        }];
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
            [MMProgressHUD dismissWithSuccess:@"注册成功" title:nil afterDelay:1.32];
        } failure:^(NSString *message) {
            NSLog(@"msg:%@",message);
            [MMProgressHUD dismissWithError:@"注册失败"];
        }];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
     */
    
}

@end
