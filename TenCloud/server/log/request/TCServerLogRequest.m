//
//  TCServerLogRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerLogRequest.h"
#import "TCServerLog+CoreDataClass.h"

@interface TCServerLogRequest()
@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, assign)   NSInteger   serverID;
@end

@implementation TCServerLogRequest

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

- (void) startWithSuccess:(void(^)(NSArray<TCServerLog*> *sLogArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *logDictArray = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *logArray = [TCServerLog mj_objectArrayWithKeyValuesArray:logDictArray context:context];
        success ? success(logArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/log/operation";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    NSString *typeStr = [NSString stringWithFormat:@"%ld",_type];
    NSString *idStr = [NSString stringWithFormat:@"%ld",_serverID];
    return @{@"object_type":typeStr,
             @"object_id":idStr
             };
}

@end
