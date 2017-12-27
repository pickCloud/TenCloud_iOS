//
//  TCModifyPasswordViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyPasswordViewController.h"
#import "VHLNavigation.h"
#import "GetCaptchaButton.h"
//#import "TCSpacingTextField.h"
#import "TCGetCaptchaRequest.h"
//#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
//#import "TCTabBarController.h"
#import "TCResetPasswordRequest.h"
#import <GT3Captcha/GT3Captcha.h>
#import "TCGeetestCaptchaRequest.h"

@interface TCModifyPasswordViewController ()<UIGestureRecognizerDelegate,GT3CaptchaManagerDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *oldPasswordField;
@property (nonatomic, weak) IBOutlet    UITextField         *captchaField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *password2Field;
@property (nonatomic, weak) IBOutlet    GetCaptchaButton    *captchaButton;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, strong)           GT3CaptchaButton    *gt3Button;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onGetCaptchaButton:(id)sender;
- (IBAction) onRegisterButton:(id)sender;
@end

@implementation TCModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    //[self vhl_setNavBarHidden:NO];
    //[self vhl_setNavBarTintColor:THEME_TINT_COLOR];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"输入原密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _oldPasswordField.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *captchaPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入验证码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _captchaField.attributedPlaceholder = captchaPlaceHolderStr;
    NSAttributedString *pwdPlaceHolderStr1 = [[NSAttributedString alloc] initWithString:@"输入新密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _passwordField.attributedPlaceholder = pwdPlaceHolderStr1;
    NSAttributedString *pwdPlaceHolderStr2 = [[NSAttributedString alloc] initWithString:@"再输入一遍"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _password2Field.attributedPlaceholder = pwdPlaceHolderStr2;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:GEETEST_API1 API2:GEETEST_API2 timeout:8.0];
    captchaManager.delegate = self;
    UIColor *maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    captchaManager.maskColor = maskColor;
    _gt3Button = [[GT3CaptchaButton alloc] initWithFrame:CGRectZero captchaManager:captchaManager];
    [_gt3Button startCaptcha];
    [self.view addSubview:self.gt3Button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    NSLog(@"on tap blank area");
    [_oldPasswordField resignFirstResponder];
    [_captchaField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_password2Field resignFirstResponder];
}

- (IBAction) onGetCaptchaButton:(id)sender
{
    NSLog(@"on get captcha button");
    [_captchaField becomeFirstResponder];
    
    if (_captchaButton.fetchState == FetchCaptchaStateNone ||
        _captchaButton.fetchState == FetchCaptchaStateRefetch)
    {
        [_captchaButton setFetchState:FetchCaptchaStateCountdown];
        NSString *phoneNum = [[TCLocalAccount shared] mobile];
        TCGetCaptchaRequest *request = [[TCGetCaptchaRequest alloc] initWithPhoneNumber:phoneNum];
        __weak __typeof(self) weakSelf = self;
        [request startWithSuccess:^(NSString *message) {
            [MBProgressHUD showSuccess:@"短信验证码已发送，请注意查收" toView:nil];
            [weakSelf.captchaField becomeFirstResponder];
        } failure:^(NSString *message, NSInteger errorCode) {
            if (errorCode == 10405)
            {
                [weakSelf.captchaField resignFirstResponder];
                [weakSelf.gt3Button startCaptcha];
            }else
            {
                [MBProgressHUD showError:message toView:nil];
            }
        }];
    }
}

- (IBAction) onRegisterButton:(id)sender
{
    NSLog(@"on register button");
    if (_oldPasswordField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入原密码" toView:nil];
        return;
    }
    if (_captchaField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return;
    }
    if (_passwordField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入新密码" toView:nil];
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
    [_oldPasswordField resignFirstResponder];
    [_captchaField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_password2Field resignFirstResponder];
    
    __weak __typeof(self) weakSelf = self;
    [MMProgressHUD showWithStatus:@"修改密码中"];
    NSString *phoneNumStr = [[TCLocalAccount shared] mobile];
    TCResetPasswordRequest *request = [[TCResetPasswordRequest alloc] initWithPhoneNumber:phoneNumStr password:_passwordField.text captcha:_captchaField.text];
    [request startWithSuccess:^(NSString *token) {
        [[TCLocalAccount shared] setToken:token];
        [[TCLocalAccount shared] save];
        [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
}


#pragma mark - GT3CaptchaManagerDelegate
- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    }
    else if (error.code == -20) {
        // 尝试过多
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
    [MBProgressHUD showError:error.localizedDescription toView:nil];
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy captchaPolicy))decisionHandler
{
    
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"User Did Close GTView.");
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    __weak __typeof(self) weakSelf = self;
    NSString *challenge = [result objectForKey:@"geetest_challenge"];
    NSString *seccode = [result objectForKey:@"geetest_seccode"];
    NSString *validate = [result objectForKey:@"geetest_validate"];
    NSString *phoneNum = [[TCLocalAccount shared] mobile];
    TCGeetestCaptchaRequest *request = [[TCGeetestCaptchaRequest alloc] initWithPhoneNumber:phoneNum challenge:challenge validate:validate seccode:seccode];
    [request startWithSuccess:^(NSString *message) {
        [weakSelf.captchaButton setFetchState:FetchCaptchaStateCountdown];
        [MBProgressHUD showSuccess:@"验证码已发送，请查收" toView:nil];
    } failure:^(NSString *message, NSInteger errorCode) {
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    return NO;
}
@end
