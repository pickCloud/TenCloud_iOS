//
//  TCStartServerRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCStartServerRequest.h"

@interface TCStartServerRequest()
@property (nonatomic, assign)       NSInteger        serverID;
@end

@implementation TCStartServerRequest

- (instancetype) initWithServerID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *status))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *status = [request.responseJSONObject objectForKey:@"data"];
        success ? success(status) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *urlstr = [NSString stringWithFormat:@"/api/server/start/%ld",_serverID];
    return urlstr;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
