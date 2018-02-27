//
//  TCUserProfileRequest.h
//  功能:获取用户信息
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCUser;
@interface TCUserProfileRequest : YTKRequest

- (void) startWithSuccess:(void(^)(TCUser *user))success
                  failure:(void(^)(NSString *message))failure;

@end
