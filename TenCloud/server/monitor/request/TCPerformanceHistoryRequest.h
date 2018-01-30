//
//  TCPerformanceHistoryRequest.h
//  功能:获取服务器监控历史记录数据
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

//@class TCServerPerformance;
@class TCPerformanceItem;
@interface TCPerformanceHistoryRequest : YTKRequest

- (instancetype) initWithServerID:(NSInteger)sid
                             type:(NSInteger)type
                        startTime:(NSInteger)startTime
                          endTime:(NSInteger)endTime
                             page:(NSInteger)page
                    amountPerPage:(NSInteger)amountPerPage;

- (void) startWithSuccess:(void(^)(NSArray<TCPerformanceItem *> *perfArray))success
                  failure:(void(^)(NSString *message))failure;

@end
