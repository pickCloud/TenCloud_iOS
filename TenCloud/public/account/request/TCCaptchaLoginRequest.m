//
//  TCCaptchaLoginRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCaptchaLoginRequest.h"

@interface TCCaptchaLoginRequest()
@property (nonatomic, strong)   NSString    *phoneNumber;
@property (nonatomic, strong)   NSString    *captcha;
@end

@implementation TCCaptchaLoginRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber captcha:(NSString *)captcha
{
    self = [super init];
    if (self)
    {
        _phoneNumber = phoneNumber;
        _captcha = captcha;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *token, NSInteger corpID))success
                  failure:(void(^)(NSString *message, NSInteger errorCode))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *token = [dataDict objectForKey:@"token"];
        NSInteger corpID = 0;
        NSNumber *corpIDNum = [dataDict objectForKey:@"cid"];
        if (corpIDNum)
        {
            corpID = corpIDNum.integerValue;
        }
        success ? success(token,corpID) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.error.code == -1009)
        {
            failure ? failure(@"网络中断，请检查网络连接",0) : nil;
            return ;
        }
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
    return @"/api/user/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"mobile":_phoneNumber,
             @"auth_code":_captcha
             };
}

@end
