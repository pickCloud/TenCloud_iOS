//
//  TCGetCaptchaRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCGetCaptchaRequest.h"

@interface TCGetCaptchaRequest()
@property (nonatomic, strong)   NSString    *phoneNumber;
@end

@implementation TCGetCaptchaRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber
{
    self = [super init];
    if (self)
    {
        _phoneNumber = phoneNumber;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"验证码已发送，请查收") : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
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
    return @{@"mobile":_phoneNumber};
}

@end
