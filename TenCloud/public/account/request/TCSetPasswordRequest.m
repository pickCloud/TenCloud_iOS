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
        //NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        //NSString *token = [dataDict objectForKey:@"token"];
        //success ? success(token) : nil;
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
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
