//
//  TCServerConfigRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerConfigRequest.h"
#import "TCServerConfig+CoreDataClass.h"

@interface TCServerConfigRequest()
@property (nonatomic, assign)   NSInteger   serverID;
@end

@implementation TCServerConfigRequest

- (instancetype) initWithServerID:(NSInteger)sid
{
    self = [super init];
    if (self)
    {
        _serverID = sid;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(TCServerConfig *config))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *configDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        TCServerConfig *config = [TCServerConfig mj_objectWithKeyValues:configDict context:context];
        success ? success(config) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        if ([message hasPrefix:@"'NoneType' object is not"])
        {
            message = @"该服务器已不存在";
        }
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/server/%ld",_serverID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end
