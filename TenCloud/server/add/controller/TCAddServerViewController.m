//
//  TCAddServerViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddServerViewController.h"
#import "TCUser+CoreDataClass.h"
#import <SocketRocket.h>
#import <AFNetworking/AFNetworking.h>

#import "TCShowAlertView.h"
#import "TCAlertController.h"
#import "UIView+TCAlertView.h"

@interface TCAddServerViewController ()<UIGestureRecognizerDelegate,SRWebSocketDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *serverNameField;
@property (nonatomic, weak) IBOutlet    UITextField         *ipField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *userNameField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, strong)           TCShowAlertView     *logAlertView;
@property (nonatomic, weak) IBOutlet    UITextView          *logTextView;
@property (nonatomic, strong)           NSMutableArray      *logTextArray;
@property (nonatomic, strong)           NSMutableString     *logText;
@property (nonatomic, strong)           TCShowAlertView     *successAlertView;
@property (nonatomic, strong)           TCShowAlertView     *failAlertView;
@property (nonatomic, strong)           SRWebSocket         *socket;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAddButton:(id)sender;
- (IBAction) onLogButton:(id)sender;
- (IBAction) onHideLogView:(id)sender;
- (IBAction) onContinueAddServer:(id)sender;
- (IBAction) onServerDetailButton:(id)sender;
- (IBAction) onFailAlertOKButton:(id)sender;
- (void) connectWebSocket;
- (void) closeWebSocket;
- (void) sendWebSocketData;
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
    _logText = [NSMutableString new];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    //NSAttributedString *serverNamePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入主机名称"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    //_serverNameField.attributedPlaceholder = serverNamePlaceHolderStr;
    //NSAttributedString *ipPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入IP"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    //_ipField.attributedPlaceholder = ipPlaceHolderStr;
    //NSAttributedString *userNamePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入用户名"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    //_userNameField.attributedPlaceholder = userNamePlaceHolderStr;
    //NSAttributedString *pwdPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    //_passwordField.attributedPlaceholder = pwdPlaceHolderStr;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    [self connectWebSocket];
    
    //test data
//    _serverNameField.text = @"测试机";
//    _ipField.text = @"119.29.239.17";
//    _userNameField.text = @"ubuntu";
//    _passwordField.text = @"Sqsm3334545";
    
//    _serverNameField.text = @"测试机2";
//    _ipField.text = @"116.62.148.13";
//    _userNameField.text = @"ubuntu";
//    _passwordField.text = @"Sqsm3334545";
    
    _serverNameField.text = @"测试机2";
    _ipField.text = @"47.96.129.231";
    _userNameField.text = @"root";
    _passwordField.text = @"Test1234";
    
//    _serverNameField.text = @"测试机2";
//    _ipField.text = @"47.97.185.147";
//    _userNameField.text = @"root";
//    _passwordField.text = @"Test1234";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [self closeWebSocket];
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
    
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    NSLog(@"status:%ld",status);
    if (status == AFNetworkReachabilityStatusNotReachable)
    {
        [MBProgressHUD showError:@"网络中断，请检查网络连接" toView:nil];
        return;
    }
    
    /*
    [MMProgressHUD showWithStatus:@"添加中"];
    if (self.socket.readyState == SR_OPEN)
    {
        [self sendWebSocketData];
        NSLog(@"sending web socket data");
    }else
    {
        [self closeWebSocket];
        [self connectWebSocket];
        [MMProgressHUD dismissWithError:@"请稍后重试"];
    }
     */
    if (self.socket.readyState == SR_OPEN)
    {
        [self sendWebSocketData];
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerViewController" owner:self options:nil];
        if (views.count >= 2)
        {
            UIView *logView = [views objectAtIndex:1];
            _logAlertView = [TCShowAlertView alertViewWithView:logView];
            _logAlertView.backgoundTapDismissEnable = YES;
            [_logAlertView show];
        }
    }else {
        [self closeWebSocket];
        [self connectWebSocket];
    }
}

- (IBAction) onLogButton:(id)sender
{
    NSLog(@"on log button");
    /*
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerViewController" owner:self options:nil];
    if (views.count >= 2)
    {
        UIView *logView = [views objectAtIndex:1];
        NSMutableString *logText = [NSMutableString new];
        [logText appendString:@"第一行abc\n"];
        [logText appendString:@"第二行bddd\n"];
        [logText appendString:@"第三行ddddzz\n"];
        _logTextView.text = logText;
        
        _logAlertView = [TCShowAlertView alertViewWithView:logView];
        _logAlertView.backgoundTapDismissEnable = YES;
        [_logAlertView show];
    }
     */
    
    /*
    //添加成功弹出框
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerViewController" owner:self options:nil];
    if (views.count >= 3)
    {
        UIView *successView = [views objectAtIndex:2];
        _successAlertView = [TCShowAlertView alertViewWithView:successView];
        //successAlert.backgoundTapDismissEnable = YES;
        [_successAlertView show];
    }
     */
    
    //添加失败弹出框
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerViewController" owner:self options:nil];
    if (views.count >= 4)
    {
        UIView *failView = [views objectAtIndex:3];
        _failAlertView = [TCShowAlertView alertViewWithView:failView];
        _failAlertView.backgoundTapDismissEnable = YES;
        [_failAlertView show];
        
        //_successAlertView = [TCShowAlertView alertViewWithView:failView];
        //successAlert.backgoundTapDismissEnable = YES;
        //[_successAlertView show];
    }
}

- (IBAction) onHideLogView:(id)sender
{
    if (_logAlertView)
    {
        [_logAlertView hide];
    }
}

- (IBAction) onContinueAddServer:(id)sender
{
    NSLog(@" on continue add server button");
    if (_successAlertView)
    {
        [_successAlertView hide];
    }
}

- (IBAction) onServerDetailButton:(id)sender
{
    //NSLog(@" on server detail button");
    if (_successAlertView)
    {
        [_successAlertView hide];
    }
}

- (IBAction) onFailAlertOKButton:(id)sender
{
    //NSLog(@"on fail alert ok button");
    if (_failAlertView)
    {
        [_failAlertView hide];
    }
}

- (void) connectWebSocket
{
    NSInteger cid = [[TCCurrentCorp shared] cid];
    NSString *token = [[TCLocalAccount shared] token];
    NSString *urlStr = [NSString stringWithFormat:@"%@?Cid=%ld&Authorization=%@",ADD_SERVER_URL, cid,token];
    NSURL *newURL = [NSURL URLWithString:urlStr];
    NSURLRequest *newRequest = [NSURLRequest requestWithURL:newURL];
    self.socket = [[SRWebSocket alloc] initWithURLRequest:newRequest];
    self.socket.delegate = self;
    [self.socket open];
}

- (void) closeWebSocket
{
    if (self.socket)
    {
        [self.socket close];
        self.socket = nil;
    }
}

- (void) sendWebSocketData
{
    NSString *serverName = _serverNameField.text;
    NSString *ip = _ipField.text;
    NSString *userName = _userNameField.text;
    NSString *password = _passwordField.text;
    NSDictionary *params = @{@"passwd":password,
                             @"username":userName,
                             @"public_ip":ip,
                             @"name":serverName,
                             @"cluster_id":@"1"
                             };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self.socket send:jsonStr];
}

#pragma mark - socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"socket did open");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"did fail:%@",error.description);
    if (webSocket == self.socket) {
        _socket = nil;
        [self connectWebSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"did close");
    if (webSocket == self.socket) {
        NSLog(@"************************** socket连接断开************************** ");
        NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self closeWebSocket];
        [self connectWebSocket];
        [MMProgressHUD dismiss];
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    NSLog(@"message:%@",message);
    if ([message isEqualToString:@"open"])
    {
        return;
    }
    
    if (webSocket == self.socket) {
        [_logTextArray addObject:message];
        NSString *rowText = [NSString stringWithFormat:@"%@\n",message];
        [_logText appendString:rowText];
        if (_logTextView)
        {
            [_logTextView setText:_logText];
        }
        if([message isEqualToString:@"success"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SERVER object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [MMProgressHUD dismissWithSuccess:@"添加成功" title:nil afterDelay:1.5];
        }else
        {
            [MMProgressHUD dismissWithError:message title:nil afterDelay:1.5];
        }
    }
}
@end
