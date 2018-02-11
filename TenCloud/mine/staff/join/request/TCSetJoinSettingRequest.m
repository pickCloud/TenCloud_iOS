//
//  TCSetJoinSettingRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSetJoinSettingRequest.h"

@interface TCSetJoinSettingRequest()

@end

@implementation TCSetJoinSettingRequest

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.ignoreCache = YES;
    }
    return self;
}


- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSInteger cid = [[TCCurrentCorp shared] cid];
    NSString *url = [NSString stringWithFormat:@"/api/company/%ld/entry/setting",cid];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return @{@"setting":_setting};
}

@end
