//
//  TCGetInviteURLRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCGetInviteURLRequest.h"


@interface TCGetInviteURLRequest()

@end

@implementation TCGetInviteURLRequest

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.ignoreCache = YES;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *urlStr))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *urlStr = [dataDict objectForKey:@"url"];
        success ? success(urlStr) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSInteger cid = [[TCCurrentCorp shared] cid];
    NSString *url = [NSString stringWithFormat:@"/api/company/%ld/entry/url",cid];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return nil;
}

@end
