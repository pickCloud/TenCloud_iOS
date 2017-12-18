//
//  TCGeetestCaptchaRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCGeetestCaptchaRequest.h"

@interface TCGeetestCaptchaRequest()
@property (nonatomic, strong)   NSString    *phoneNumber;
@property (nonatomic, strong)   NSString    *challenge;
@property (nonatomic, strong)   NSString    *validate;
@property (nonatomic, strong)   NSString    *seccode;
@end

@implementation TCGeetestCaptchaRequest

/*
- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber
{
    self = [super init];
    if (self)
    {
        _phoneNumber = phoneNumber;
    }
    return self;
}
 */

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber challenge:(NSString*)challenge validate:(NSString*)validate seccode:(NSString*)seccode
{
    self = [super init];
    if (self)
    {
        _phoneNumber = phoneNumber;
        _challenge = challenge;
        _validate = validate;
        _seccode = seccode;
        _challenge = challenge ? challenge : @"";
        _validate = validate ? validate : @"";
        _seccode = seccode ? seccode : @"";
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message, NSInteger errorCode))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"验证码已发送，请查收") : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSNumber *resNumber = [request.responseJSONObject objectForKey:@"status"];
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        if (resNumber.integerValue == 10404)
        {
            NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
            NSString *token = [dataDict objectForKey:@"token"];
            message = token;
        }
        failure ? failure(message,resNumber.integerValue) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/sms";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"mobile":_phoneNumber,
             @"geetest_challenge":_challenge,
             @"geetest_validate":_validate,
             @"geetest_seccode":_seccode
             };
}

@end
