//
//  TCModifyServerNameRequest.h
//  功能:修改服务器名称
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCModifyServerNameRequest : YTKRequest

- (instancetype) initWithServerID:(NSInteger)sid name:(NSString*)name;

- (void) startWithSuccess:(void(^)(NSString *status))success
                  failure:(void(^)(NSString *message))failure;

@end
