//
//  TCMessageCountRequest.h
//  功能:获取消息数量
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCMessageCountRequest : YTKRequest

- (instancetype) initWithStatus:(NSInteger)status;

- (void) startWithSuccess:(void(^)(NSInteger count))success
                  failure:(void(^)(NSString *message))failure;

@end
