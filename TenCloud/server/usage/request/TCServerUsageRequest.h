//
//  TCServerUsageRequest.h
//  功能:获取服务器使用率数据列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServerUsage;
@interface TCServerUsageRequest : YTKRequest

- (void) startWithSuccess:(void(^)(NSArray<TCServerUsage*> *usageArray))success
                  failure:(void(^)(NSString *message))failure;

- (NSArray<TCServerUsage*> *)resultUsageArray;

@end
