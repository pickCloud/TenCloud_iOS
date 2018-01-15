//
//  TCAcceptInviteRequest.h
//  功能:接受公司邀请
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCAcceptInviteRequest : YTKRequest

- (instancetype) initWithCode:(NSString*)code;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
