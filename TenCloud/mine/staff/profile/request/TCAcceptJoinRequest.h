//
//  TCAcceptJoinRequest.h
//  功能:管理员接受员工加入
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCAcceptJoinRequest : YTKRequest

@property (nonatomic, assign)   NSInteger    staffID;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
