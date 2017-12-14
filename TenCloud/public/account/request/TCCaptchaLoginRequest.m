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

/*
+ (TCPasswordLoginRequest *)requestWithPhoneNumber:(NSString *)phoneNumber
                                  password:(NSString *)password
                                   success:(void(^)(NSString *token))success
                                   failure:(void(^)(NSString *message))failure
{
    TCPasswordLoginRequest *request = [[TCPasswordLoginRequest alloc] initWithPhoneNumber:phoneNumber password:password];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *token = [dataDict objectForKey:@"token"];
        success ? success(token) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
    return request;
}
 */

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *token = [dataDict objectForKey:@"token"];
        success ? success(token) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSNumber *resNumber = [request.responseJSONObject objectForKey:@"status"];
        if (resNumber.integerValue == 10404)
        {
            NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
            NSString *token = [dataDict objectForKey:@"token"];
            success ? success(token) : nil;
            return ;
        }
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
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
