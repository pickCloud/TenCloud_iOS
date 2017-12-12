//
//  TCServerContainerListRequest.h
//  功能:获取服务器容器列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCServerContainerListRequest : YTKRequest

- (instancetype) initWithServerID:(NSInteger)sid;

- (void) startWithSuccess:(void(^)(NSArray<NSArray*> *containerArray))success
                  failure:(void(^)(NSString *message))failure;

@end
