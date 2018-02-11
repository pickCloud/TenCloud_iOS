//
//  TCServerStatusRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerStatusRequest.h"

@interface TCServerStatusRequest()
@property (nonatomic, strong)       NSString    *instanceID;
@end

@implementation TCServerStatusRequest

- (instancetype) initWithInstanceID:(NSString*)instanceID
{
    self = [super init];
    if (self)
    {
        _instanceID = instanceID;
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
    NSString *urlstr = [NSString stringWithFormat:@"/api/server/%@/status",_instanceID];
    return urlstr;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
