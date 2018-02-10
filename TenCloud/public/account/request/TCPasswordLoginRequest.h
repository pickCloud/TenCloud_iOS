//
//  TCPasswordLoginRequest.h
//  功能:账号密码登录请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCPasswordLoginRequest : YTKRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password;

- (void) startWithSuccess:(void(^)(NSString *token, NSInteger corpID))success
                  failure:(void(^)(NSString *message))failure;

/*
+ (TCPasswordLoginRequest *)requestWithPhoneNumber:(NSString *)phoneNumber
                                  password:(NSString *)password
                                  success:(void(^)(NSString *token))success
                                  failure:(void(^)(NSString *message))failure;
 */

@end
