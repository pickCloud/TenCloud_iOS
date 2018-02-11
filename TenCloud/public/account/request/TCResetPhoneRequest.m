//
//  TCResetPhoneRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCResetPhoneRequest.h"

@interface TCResetPhoneRequest()
@property (nonatomic, strong)   NSString    *phoneNumber;
@property (nonatomic, strong)   NSString    *password;
@property (nonatomic, strong)   NSString    *captcha;
@end

@implementation TCResetPhoneRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password captcha:(NSString *)captcha
{
    self = [super init];
    if (self)
    {
        _phoneNumber = phoneNumber;
        _password = password;
        _captcha = captcha;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *resToken = [dataDict objectForKey:@"token"];
        success ? success(resToken) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/password/reset";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"new_mobile":_phoneNumber,
             @"password":_password,
             @"auth_code":_captcha
             };
}

@end
