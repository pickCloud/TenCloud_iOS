//
//  TCAccessKeyRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAccessKeyRequest.h"

@interface TCAccessKeyRequest()
@end

@implementation TCAccessKeyRequest

- (void) startWithSuccess:(void(^)(NSString *status))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *status = [request.responseJSONObject objectForKey:@"data"];
        success ? success(status) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/clouds/credentials";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    NSDictionary *contentDict = @{@"access_key":_accessKey,@"access_secret":_accessSecret};
    return @{@"cloud_type":@(_cloudID),
             @"content":contentDict
             };
}
@end
