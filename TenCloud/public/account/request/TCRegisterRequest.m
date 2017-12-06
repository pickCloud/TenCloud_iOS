//
//  TCRegisterRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCRegisterRequest.h"

@interface TCRegisterRequest()
@property (nonatomic, strong)   NSString    *phoneNumber;
@property (nonatomic, strong)   NSString    *password;
@property (nonatomic, strong)   NSString    *captcha;
@end

@implementation TCRegisterRequest

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

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"注册成功") : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/register";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"mobile":_phoneNumber,
             @"password":_password,
             @"auth_code":_captcha
             };
}

@end
