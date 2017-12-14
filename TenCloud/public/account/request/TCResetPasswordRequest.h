//
//  TCResetPasswordRequest.h
//  功能:重置密码请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCResetPasswordRequest : YTKRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password captcha:(NSString *)captcha;

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message))failure;

@end
