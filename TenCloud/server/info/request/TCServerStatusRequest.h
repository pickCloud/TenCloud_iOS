//
//  TCServerStatusRequest.h
//  功能:获取服务器当前状态
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCServerStatusRequest : YTKRequest

- (instancetype) initWithInstanceID:(NSString*)instanceID;

- (void) startWithSuccess:(void(^)(NSString *status))success
                  failure:(void(^)(NSString *message))failure;

@end
