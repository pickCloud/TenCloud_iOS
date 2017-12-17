//
//  TCSetPasswordRequest.h
//  功能:设置密码请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCSetPasswordRequest : YTKRequest

- (instancetype) initWithPassword:(NSString *)password;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
