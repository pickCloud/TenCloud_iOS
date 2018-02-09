//
//  TCServerPerformanceRequest.m
//
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerPerformanceRequest.h"
#import "TCServerPerformance+CoreDataClass.h"

@interface TCServerPerformanceRequest()
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, assign)   NSInteger   end_time;
@property (nonatomic, assign)   NSInteger   start_time;
@end

@implementation TCServerPerformanceRequest

- (instancetype) initWithServerID:(NSInteger)sid type:(NSInteger)type
                        startTime:(NSInteger)startTime endTime:(NSInteger)endTime
{
    self = [super init];
    if (self)
    {
        _serverID = sid;
        _type = type;
        _start_time = startTime;
        _end_time = endTime;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(TCServerPerformance *performance))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *perfDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        TCServerPerformance *performance = [TCServerPerformance mj_objectWithKeyValues:perfDict context:context];
        success ? success(performance) : nil;
        //NSArray *containerDictArray = [request.responseJSONObject objectForKey:@"data"];
        //NSLog(@"container array:%@",containerDictArray);
        //NSArray *containerArray = [NSArray mj_objectArrayWithKeyValuesArray:containerDictArray];
        
        //success ? success(containerArray) : nil;
        
        /*
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *logArray = [TCServerLog mj_objectArrayWithKeyValuesArray:logDictArray context:context];
        success ? success(logArray) : nil;
         */
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
    return @"/api/server/performance";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument
{
    NSString *idStr = [NSString stringWithFormat:@"%ld",_serverID];
    NSString *startStr = [NSString stringWithFormat:@"%ld",_start_time];
    NSString *endStr = [NSString stringWithFormat:@"%ld",_end_time];
    return @{
             @"id":idStr,
             @"type":@(_type),
             @"start_time":startStr,
             @"end_time":endStr
             };
}
@end
