//
//  TCServerUsageRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerUsageRequest.h"
#import "TCServerUsage+CoreDataClass.h"

@interface TCServerUsageRequest()
//@property (nonatomic, assign)   NSInteger   type;
//@property (nonatomic, assign)   NSInteger   serverID;
@end

@implementation TCServerUsageRequest

/*
- (instancetype) initWithServerID:(NSInteger)sid type:(NSInteger)type
{
    self = [super init];
    if (self)
    {
        _serverID = sid;
        _type = type;
    }
    return self;
}
 */

- (void) startWithSuccess:(void(^)(NSArray<TCServerUsage*> *usageArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *logDictArray = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *logArray = [TCServerUsage mj_objectArrayWithKeyValuesArray:logDictArray context:context];
        success ? success(logArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/server/monitor";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

/*
- (id)requestArgument
{
    NSString *typeStr = [NSString stringWithFormat:@"%ld",_type];
    NSString *idStr = [NSString stringWithFormat:@"%ld",_serverID];
    return @{@"object_type":typeStr,
             @"object_id":idStr
             };
}
 */

@end
