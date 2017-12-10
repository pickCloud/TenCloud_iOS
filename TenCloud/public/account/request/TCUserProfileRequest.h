//
//  TCUserProfileRequest.h
//  功能:获取用户信息
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCUser;
@interface TCUserProfileRequest : YTKRequest

//- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password;

- (void) startWithSuccess:(void(^)(TCUser *user))success
                  failure:(void(^)(NSString *message))failure;

/*
+ (TCPasswordLoginRequest *)requestWithPhoneNumber:(NSString *)phoneNumber
                                  password:(NSString *)password
                                  success:(void(^)(NSString *token))success
                                  failure:(void(^)(NSString *message))failure;
 */

@end
