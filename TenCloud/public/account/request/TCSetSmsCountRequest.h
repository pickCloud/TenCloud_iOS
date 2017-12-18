//
//  TCSetSmsCountRequest.h
//  功能:设置服务端短信验证码发送次数,正式版应删除
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCSetSmsCountRequest : YTKRequest

- (instancetype) initWithCount:(NSInteger)count;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
