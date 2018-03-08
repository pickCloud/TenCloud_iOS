//
//  TCServerProfileRequest.h
//  功能:获取服务器配置
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCSystemLoad;
@interface TCSystemLoadRequest : YTKRequest

- (instancetype) initWithServerID:(NSInteger)sid;

- (void) startWithSuccess:(void(^)(TCSystemLoad *sysLoad))success
                  failure:(void(^)(NSString *message))failure;

@end
