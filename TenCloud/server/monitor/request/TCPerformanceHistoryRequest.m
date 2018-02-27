//
//  TCPerformanceHistoryRequest.m
//
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPerformanceHistoryRequest.h"
#import "TCPerformanceItem+CoreDataClass.h"

@interface TCPerformanceHistoryRequest()
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, assign)   NSInteger   type;
@property (nonatomic, assign)   NSInteger   end_time;
@property (nonatomic, assign)   NSInteger   start_time;
@property (nonatomic, assign)   NSInteger   page;
@property (nonatomic, assign)   NSInteger   amountPerPage;
@end

@implementation TCPerformanceHistoryRequest

- (instancetype) initWithServerID:(NSInteger)sid
                             type:(NSInteger)type
                        startTime:(NSInteger)startTime
                          endTime:(NSInteger)endTime
                             page:(NSInteger)page
                    amountPerPage:(NSInteger)amountPerPage
{
    self = [super init];
    if (self)
    {
        _serverID = sid;
        _type = type;
        _start_time = startTime;
        _end_time = endTime;
        _page = page;
        _amountPerPage = amountPerPage;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCPerformanceItem *> *perfArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *perfDictArray = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *perfArray = [TCPerformanceItem mj_objectArrayWithKeyValuesArray:perfDictArray context:context];
        success ? success(perfArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
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
             @"end_time":endStr,
             @"now_page":@(_page),
             @"page_number":@(_amountPerPage)
             };
}
@end
