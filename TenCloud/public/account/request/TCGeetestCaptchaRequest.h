//
//  TCGeetestCaptchaRequest.h
//  功能:极验证判断后，获取手机验证码
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCGeetestCaptchaRequest : YTKRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber challenge:(NSString*)challenge validate:(NSString*)validate seccode:(NSString*)seccode;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message, NSInteger errorCode))failure;

@end
