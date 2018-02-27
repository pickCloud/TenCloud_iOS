//
//  TCSetPasswordViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSetPasswordViewController.h"
#import "TCUser+CoreDataClass.h"
#import "TCTabBarController.h"
#import "TCSetPasswordRequest.h"

@interface TCSetPasswordViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *password2Field;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onLoginButton:(id)sender;
@end

@implementation TCSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    
    NSAttributedString *pwdPlaceHolderStr1 = [[NSAttributedString alloc] initWithString:@"请输入密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _passwordField.attributedPlaceholder = pwdPlaceHolderStr1;
    NSAttributedString *pwdPlaceHolderStr2 = [[NSAttributedString alloc] initWithString:@"请再输入密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _password2Field.attributedPlaceholder = pwdPlaceHolderStr2;
    
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
    [_passwordField resignFirstResponder];
    [_password2Field resignFirstResponder];
}

- (IBAction) onLoginButton:(id)sender
{
    NSLog(@"on register button");
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
    [_passwordField resignFirstResponder];
    [_password2Field resignFirstResponder];
    
    [MMProgressHUD showWithStatus:@"登录中"];
    TCSetPasswordRequest *request = [[TCSetPasswordRequest alloc] initWithPassword:_passwordField.text];
    [request startWithSuccess:^(NSString *message) {
        TCTabBarController *tabBarController = [TCTabBarController new];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
        [MMProgressHUD dismissWithSuccess:@"登录成功" title:nil afterDelay:1.32];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
}

@end
