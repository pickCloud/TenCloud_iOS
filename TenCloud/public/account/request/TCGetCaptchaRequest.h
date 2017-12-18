//
//  TCGetCaptchaRequest.h
//  功能:获取手机验证码
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCGetCaptchaRequest : YTKRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message, NSInteger errorCode))failure;

@end
