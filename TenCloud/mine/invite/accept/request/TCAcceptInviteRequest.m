//
//  TCAcceptInviteRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAcceptInviteRequest.h"

@interface TCAcceptInviteRequest()
@property (nonatomic, strong)   NSString    *code;
@end

@implementation TCAcceptInviteRequest

- (instancetype) initWithCode:(NSString*)code
{
    self = [super init];
    if (self)
    {
        _code = code;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"完成接受邀请") : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/application/waiting";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"code":_code};
}
@end
