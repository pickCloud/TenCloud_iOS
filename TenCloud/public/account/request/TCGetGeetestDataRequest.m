//
//  TCGetGeetestDataRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCGetGeetestDataRequest.h"

@interface TCGetGeetestDataRequest()
//@property (nonatomic, strong)   NSString    *phoneNumber;
@end

@implementation TCGetGeetestDataRequest

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

- (void) startWithSuccess:(void(^)(NSString *gt, NSString *challenge))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        //success ? success(@"验证码已发送，请查收") : nil;
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            NSString *gt = [dataDict objectForKey:@"gt"];
            NSString *challenge = [dataDict objectForKey:@"challenge"];
            success ? success(gt,challenge) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/captcha";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

/*
- (id)requestArgument
{
    return @{@"mobile":_phoneNumber};
}
 */

@end
