//
//  TCServerLogRequest.h
//  功能:获取服务器日志列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServerLog;
@interface TCServerLogRequest : YTKRequest

- (instancetype) initWithServerID:(NSInteger)sid type:(NSInteger)type;

- (void) startWithSuccess:(void(^)(NSArray<TCServerLog*> *logArray))success
                  failure:(void(^)(NSString *message))failure;

@end
