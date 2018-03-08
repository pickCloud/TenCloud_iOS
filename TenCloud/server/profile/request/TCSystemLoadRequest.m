//
//  TCSystemLoadRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSystemLoadRequest.h"
#import "TCSystemLoad+CoreDataClass.h"

@interface TCSystemLoadRequest()
@property (nonatomic, assign)   NSInteger   serverID;
@end

@implementation TCSystemLoadRequest

- (instancetype) initWithServerID:(NSInteger)sid
{
    self = [super init];
    if (self)
    {
        _serverID = sid;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(TCSystemLoad *sysLoad))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *configDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        TCSystemLoad *load = [TCSystemLoad mj_objectWithKeyValues:configDict context:context];
        success ? success(load) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        if ([message hasPrefix:@"'NoneType' object is not"])
        {
            message = @"该服务器已不存在";
            failure ? failure(message) : nil;
        }else
        {
            failure ? failure([self errorMessaage]) : nil;
        }
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/server/%ld/systemload",_serverID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end
