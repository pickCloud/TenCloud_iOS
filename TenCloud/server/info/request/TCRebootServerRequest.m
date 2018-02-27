//
//  TCRebootServerRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCRebootServerRequest.h"

@interface TCRebootServerRequest()
@property (nonatomic, assign)       NSInteger        serverID;
@end

@implementation TCRebootServerRequest

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
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *urlstr = [NSString stringWithFormat:@"/api/server/reboot/%ld",_serverID];
    return urlstr;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
