//
//  TCDeleteServerRequest.h
//  功能:删除服务器
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCDeleteServerRequest : YTKRequest

- (instancetype) initWithServerID:(NSInteger)serverID;

- (void) startWithSuccess:(void(^)(NSString *status))success
                  failure:(void(^)(NSString *message))failure;

@end
