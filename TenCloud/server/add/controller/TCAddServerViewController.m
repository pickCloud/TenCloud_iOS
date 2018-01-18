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

@interface TCAddServerViewController ()<UIGestureRecognizerDelegate,SRWebSocketDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *serverNameField;
@property (nonatomic, weak) IBOutlet    UITextField         *ipField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *userNameField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, strong)           SRWebSocket         *socket;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAddButton:(id)sender;
- (void) connectWebSocket;
- (void) closeWebSocket;
- (void) sendWebSocketData;
@end

@implementation TCAddServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加主机";
    
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
    
    [self connectWebSocket];
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
    
    [MMProgressHUD showWithStatus:@"添加中"];
    if (self.socket.readyState == SR_OPEN)
    {
        [self sendWebSocketData];
        NSLog(@"sending web socket data");
    }else
    {
        [self closeWebSocket];
        [self connectWebSocket];
        //[MBProgressHUD showError:@"请稍后重试" toView:nil];
        [MMProgressHUD dismissWithError:@"请稍后重试"];
        NSLog(@"稍后重试");
    }
}

- (void) connectWebSocket
{
    NSURL *newURL = [NSURL URLWithString:@"https://c.10.com/api/server/new"];
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
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    if (webSocket == self.socket) {
        _socket = nil;
        [self connectWebSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
    if (webSocket == self.socket) {
        //NSLog(@"************************** socket连接断开************************** ");
        //NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self closeWebSocket];
        [self connectWebSocket];
        //[MMProgressHUD dismiss];
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    if ([message isEqualToString:@"open"])
    {
        return;
    }
    
    if (webSocket == self.socket) {
        NSLog(@"message:%@",message);
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
