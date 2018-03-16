//
//  TCServerThresholdRequest.h
//  功能: 获取服务器首页 使用率临界值 数据
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServerThreshold;
@interface TCServerThresholdRequest : YTKRequest

- (void) startWithSuccess:(void(^)(TCServerThreshold *threshold))success
                  failure:(void(^)(NSString *message))failure;

@end
