//
//  TCAddServerManager.m
//  TenCloud
//
//  Created by huangdx on 2018/2/11.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAddServerManager.h"
#import <SocketRocket.h>

@interface TCAddServerManager ()<SRWebSocketDelegate>
@property (nonatomic, strong)   SRWebSocket     *socket;
@property (nonatomic, strong)   NSString        *serverName;
@property (nonatomic, strong)   NSString        *ip;
@property (nonatomic, strong)   NSString        *userName;
@property (nonatomic, strong)   NSString        *password;
@end

@implementation TCAddServerManager

+ (instancetype) shared
{
    static TCAddServerManager *instance;
    static dispatch_once_t managerDisp;
    dispatch_once(&managerDisp, ^{
        instance = [[TCAddServerManager alloc] init];
    });
    return instance;
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

- (void) addServerWithName:(NSString*)name ip:(NSString*)ip
                  userName:(NSString*)userName
                  password:(NSString*)password
{
    _serverName = name;
    _ip = ip;
    _userName = userName;
    _password = password;
    [self closeWebSocket];
    [self connectWebSocket];
}

- (void) closeWebSocket
{
    if (self.socket)
    {
        [self.socket close];
        self.socket = nil;
    }
}

- (void) sendAddServerData
{
    if (self.socket)
    {
        NSDictionary *params = @{@"passwd":_password,
                                 @"username":_userName,
                                 @"public_ip":_ip,
                                 @"name":_serverName,
                                 @"cluster_id":@"1"
                                 };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.socket send:jsonStr];
    }
}


#pragma mark - socket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"socket did open");
    [self sendAddServerData];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"did fail:%@",error.description);
    if (_delegate && [_delegate respondsToSelector:@selector(addServerManager:receiveFailMessage:)])
    {
        [_delegate addServerManager:self receiveFailMessage:error.localizedDescription];
    }
    if (webSocket == self.socket) {
        _socket = nil;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"did close");
    if (webSocket == self.socket) {
        NSLog(@"************************** socket连接断开************************** ");
        NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self closeWebSocket];
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
        if([message isEqualToString:@"success"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_SERVER object:nil];
            NSLog(@"成功添加主机哦哦哦哦哦!!!");
            if (_delegate && [_delegate respondsToSelector:@selector(addServerManager:receiveSuccessMessage:)])
            {
                [_delegate addServerManager:self receiveSuccessMessage:message];
            }
        }else if([message isEqualToString:@"failure"])
        {
            if (_delegate && [_delegate respondsToSelector:@selector(addServerManager:receiveLogMessage:)])
            {
                [_delegate addServerManager:self receiveLogMessage:message];
            }
            if (_delegate && [_delegate respondsToSelector:@selector(addServerManager:receiveFailMessage:)])
            {
                [_delegate addServerManager:self receiveFailMessage:message];
            }
        }else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(addServerManager:receiveLogMessage:)])
            {
                [_delegate addServerManager:self receiveLogMessage:message];
            }
        }
    }
}
@end
