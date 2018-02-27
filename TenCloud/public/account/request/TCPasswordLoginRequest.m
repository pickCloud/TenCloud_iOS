//
//  TCPasswordLoginRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPasswordLoginRequest.h"

@interface TCPasswordLoginRequest()
@property (nonatomic, strong)   NSString    *phoneNumber;
@property (nonatomic, strong)   NSString    *password;
@end

@implementation TCPasswordLoginRequest

- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password
{
    self = [super init];
    if (self)
    {
        _phoneNumber = phoneNumber;
        _password = password;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *token, NSInteger corpID))success
                  failure:(void(^)(NSString *message))failure
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
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        if (request.error.code == -1009)
        {
            failure ? failure(@"网络中断，请检查网络连接") : nil;
        }else
        {
            failure ? failure(message) : nil;
        }
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/login/password";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"mobile":_phoneNumber,
             @"password":_password
             };
}

@end
