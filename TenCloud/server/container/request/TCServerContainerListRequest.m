//
//  TCServerContainerListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerContainerListRequest.h"
#import "TCServerLog+CoreDataClass.h"

@interface TCServerContainerListRequest()
@property (nonatomic, assign)   NSInteger   serverID;
@end

@implementation TCServerContainerListRequest

- (instancetype) initWithServerID:(NSInteger)sid
{
    self = [super init];
    if (self)
    {
        _serverID = sid;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<NSArray*> *containerArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *containerDictArray = [request.responseJSONObject objectForKey:@"data"];
        NSLog(@"container array:%@",containerDictArray);
        NSArray *containerArray = [NSArray mj_objectArrayWithKeyValuesArray:containerDictArray];
        success ? success(containerArray) : nil;
        /*
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *logArray = [TCServerLog mj_objectArrayWithKeyValuesArray:logDictArray context:context];
        success ? success(logArray) : nil;
         */
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/server/containers/%ld",_serverID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
/*
- (id)requestArgument
{
    
    NSString *idStr = [NSString stringWithFormat:@"%ld",_serverID];
    return @{
             @"object_id":idStr
             };
     
    return nil;
}
*/
@end
