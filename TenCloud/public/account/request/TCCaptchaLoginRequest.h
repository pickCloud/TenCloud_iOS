//
//  TCCaptchaLoginRequest.h
//  功能:手机验证码登录请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCCaptchaLoginRequest : YTKRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber captcha:(NSString *)captcha;

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message, NSInteger errorCode))failure;

@end
