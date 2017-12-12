//
//  TCServerPerformanceRequest.h
//  功能:获取服务器监控页面数据
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServerPerformance;
@interface TCServerPerformanceRequest : YTKRequest

- (instancetype) initWithServerID:(NSInteger)sid type:(NSInteger)type
                        startTime:(NSInteger)startTime endTime:(NSInteger)endTime;

- (void) startWithSuccess:(void(^)(TCServerPerformance *performance))success
                  failure:(void(^)(NSString *message))failure;

@end
