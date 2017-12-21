//
//  TCAddServerViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddServerViewController.h"
#import "VHLNavigation.h"
#import "TCUser+CoreDataClass.h"

@interface TCAddServerViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *serverNameField;
@property (nonatomic, weak) IBOutlet    UITextField         *ipField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *userNameField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAddButton:(id)sender;
@end

@implementation TCAddServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加主机";
    [self vhl_setNavBarHidden:NO];
    [self vhl_setNavBarTintColor:THEME_TINT_COLOR];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    NSAttributedString *serverNamePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入主机名称"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _serverNameField.attributedPlaceholder = serverNamePlaceHolderStr;
    NSAttributedString *ipPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入IP"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _ipField.attributedPlaceholder = ipPlaceHolderStr;
    NSAttributedString *userNamePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入用户名"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _userNameField.attributedPlaceholder = userNamePlaceHolderStr;
    NSAttributedString *pwdPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _passwordField.attributedPlaceholder = pwdPlaceHolderStr;
    
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
    [_serverNameField resignFirstResponder];
    [_ipField resignFirstResponder];
    [_userNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (IBAction) onAddButton:(id)sender
{
    NSLog(@"on register button");
    if (_serverNameField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入主机名称" toView:nil];
        return;
    }
    if (_ipField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入IP地址" toView:nil];
        return;
    }
    if (_userNameField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入用户名" toView:nil];
        return;
    }
    if (_passwordField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入密码" toView:nil];
        return;
    }
    [_serverNameField resignFirstResponder];
    [_ipField resignFirstResponder];
    [_userNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
}

@end
