//
//  TCSetPasswordRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSetPasswordRequest.h"

@interface TCSetPasswordRequest()
@property (nonatomic, strong)   NSString    *password;
@end

@implementation TCSetPasswordRequest

- (instancetype) initWithPassword:(NSString *)password
{
    self = [super init];
    if (self)
    {
        _password = password;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/password/set";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"password":_password};
}

@end
