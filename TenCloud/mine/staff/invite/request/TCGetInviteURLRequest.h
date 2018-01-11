//
//  TCGetInviteURLRequest.h
//  功能:获取邀请员工URL
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCGetInviteURLRequest : YTKRequest

- (void) startWithSuccess:(void(^)(NSString *urlStr))success
                  failure:(void(^)(NSString *message))failure;

@end
