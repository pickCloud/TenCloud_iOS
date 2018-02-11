//
//  TCAddServerManager.h
//  TenCloud
//
//  Created by huangdx on 2018/2/11.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCAddServerManager;
@protocol TCAddServerManagerDelegate<NSObject>
- (void) addServerManager:(TCAddServerManager*)manager receiveSuccessMessage:(NSString*)message;
- (void) addServerManager:(TCAddServerManager*)manager receiveFailMessage:(NSString*)message;
- (void) addServerManager:(TCAddServerManager*)manager receiveLogMessage:(NSString*)message;
@end
@interface TCAddServerManager : NSObject

+ (instancetype) shared;

- (void) connectWebSocket;

- (void) addServerWithName:(NSString*)name ip:(NSString*)ip
                  userName:(NSString*)userName
                  password:(NSString*)password;

- (void) closeWebSocket;

@property (nonatomic, assign)  id<TCAddServerManagerDelegate>      delegate;

@end
