//
//  TCAddServerViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddServerViewController.h"
#import "TCUser+CoreDataClass.h"
#import <AFNetworking/AFNetworking.h>
#import "TCAddServerManager.h"
#import "TCAddServerLogView.h"
#import "TCAddServerSuccessView.h"
#import "TCAddServerFailView.h"
#import "TCShowAlertView.h"
#import "UIView+TCAlertView.h"

#define ADDING_SERVER_BUTTON_TITLE  @"正在添加...请稍候..."

@interface TCAddServerViewController ()<UIGestureRecognizerDelegate,TCAddServerManagerDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *serverNameField;
@property (nonatomic, weak) IBOutlet    UITextField         *ipField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *userNameField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UIButton            *addServerButton;
@property (nonatomic, strong)           TCAddServerLogView  *mLogView;
@property (nonatomic, strong)           UIView              *mSuccessView;
@property (nonatomic, strong)           UIView              *mFailView;
@property (nonatomic, strong)           TCShowAlertView     *logAlertView;
@property (nonatomic, strong)           NSMutableArray      *logTextArray;
@property (nonatomic, strong)           NSMutableAttributedString   *logText;
@property (nonatomic, strong)           TCShowAlertView     *successAlertView;
@property (nonatomic, strong)           TCShowAlertView     *failAlertView;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAddButton:(id)sender;
- (IBAction) onLogButton:(id)sender;
- (void) showLogAlertView;
- (void) showSuccessAlertView;
- (void) showFailAlertView:(NSString*)message;
- (void) resetToReady;
@end

@implementation TCAddServerViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加主机";
    _logTextArray = [NSMutableArray new];
    _logText = [NSMutableAttributedString new];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    //[self connectWebSocket];
    
    //test data
//    _serverNameField.text = @"测试机";
//    _ipField.text = @"119.29.239.17";
//    _userNameField.text = @"ubuntu";
//    _passwordField.text = @"Sqsm3334545";
    
//    _serverNameField.text = @"测试机2";
//    _ipField.text = @"116.62.148.13";
//    _userNameField.text = @"ubuntu";
//    _passwordField.text = @"Sqsm3334545";
    
    //_serverNameField.text = @"测试机2";
    //_ipField.text = @"47.96.129.231";
    //_userNameField.text = @"root";
    //_passwordField.text = @"Test1234";
    
//    _serverNameField.text = @"测试机2";
//    _ipField.text = @"47.97.185.147";
//    _userNameField.text = @"root";
//    _passwordField.text = @"Test1234";
    
    [[TCAddServerManager shared] setDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[TCAddServerManager shared] setDelegate:nil];
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    [_serverNameField resignFirstResponder];
    [_ipField resignFirstResponder];
    [_userNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (IBAction) onAddButton:(id)sender
{
    if ([_addServerButton.titleLabel.text isEqualToString:ADDING_SERVER_BUTTON_TITLE])
    {
        return;
    }
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
    
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    NSLog(@"status:%ld",status);
    if (status == AFNetworkReachabilityStatusNotReachable)
    {
        [MBProgressHUD showError:@"网络中断，请检查网络连接" toView:nil];
        return;
    }
    
    //clear and reset old data
    [_logTextArray removeAllObjects];
    if (_logText.length > 0)
    {
        NSRange deleteRange = NSMakeRange(0, _logText.length);
        [_logText deleteCharactersInRange:deleteRange];
    }
    
    [[TCAddServerManager shared] addServerWithName:_serverNameField.text
                                                ip:_ipField.text
                                          userName:_userNameField.text
                                          password:_passwordField.text];
    UIColor *addingColor = [UIColor colorWithRed:86/255.0 green:148/255.0 blue:156/255.0 alpha:1.0];
    [_addServerButton setTitle:ADDING_SERVER_BUTTON_TITLE forState:UIControlStateNormal];
    [_addServerButton setTitleColor:addingColor forState:UIControlStateNormal];
    [self showLogAlertView];
}

- (IBAction) onLogButton:(id)sender
{
    [self showLogAlertView];
}

- (void) showLogAlertView
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerLogView"
                                                   owner:self options:nil];
    if (views.count > 0)
    {
        _mLogView = views.firstObject;
        _logAlertView = [TCShowAlertView alertViewWithView:_mLogView];
        _logAlertView.backgoundTapDismissEnable = YES;
        [_mLogView setAttrText:_logText];
        [_logAlertView show];
    }
}

- (void) showSuccessAlertView
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerSuccessView" owner:nil options:nil];
    if (views.count > 0)
    {
        __weak __typeof(self) weakSelf = self;
        __block TCAddServerSuccessView *successView = views.firstObject;
        successView.checkBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        successView.continueBlock = ^{
            
        };
        _successAlertView = [TCShowAlertView alertViewWithView:successView];
        _successAlertView.backgoundTapDismissEnable = YES;
        [_successAlertView show];
    }
}

- (void) showFailAlertView:(NSString*)message
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerFailView" owner:nil options:nil];
    if (views.count > 0)
    {
        TCAddServerFailView *successView = views.firstObject;
        successView.descLabel.text = message;
        successView.continueBlock = ^{
            
        };
        _failAlertView = [TCShowAlertView alertViewWithView:successView];
        _failAlertView.backgoundTapDismissEnable = YES;
        [_failAlertView show];
    }
}

- (void) resetToReady
{
    [_addServerButton setTitle:@"确定添加" forState:UIControlStateNormal];
    [_addServerButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [_serverNameField setText:@""];
    [_ipField setText:@""];
    [_passwordField setText:@""];
    [_userNameField setText:@""];
}

 
#pragma mark - TCAddServerManagerDelegate
- (void) addServerManager:(TCAddServerManager*)manager receiveSuccessMessage:(NSString*)message
{
    if (_logAlertView)
    {
        [_logAlertView hide];
    }
    [self resetToReady];
    [self showSuccessAlertView];
}

- (void) addServerManager:(TCAddServerManager*)manager receiveFailMessage:(NSString*)message
{
    NSString *errorMessage = @"服务器未返回失败原因";
    if (_logTextArray.count >= 2)
    {
        errorMessage = [_logTextArray objectAtIndex:_logTextArray.count - 2];
    }
    if (_logAlertView)
    {
        [_logAlertView hideWithoutAnimation];
    }
    [self resetToReady];
    [self showFailAlertView:errorMessage];
}

- (void) addServerManager:(TCAddServerManager*)manager receiveLogMessage:(NSString*)message
{
    [_logTextArray addObject:message];
    NSString *tmpstr = [NSString stringWithFormat:@"%@\n",message];
    NSAttributedString *msgStr = [[NSAttributedString alloc] initWithString:tmpstr  attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    [_logText appendAttributedString:msgStr];
    if (_mLogView)
    {
        [_mLogView setAttrText:_logText];
    }
}
@end
