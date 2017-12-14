//
//  TCRegisterRequest.h
//  功能:注册账号网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCRegisterRequest : YTKRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password captcha:(NSString *)captcha;

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message))failure;

@end
