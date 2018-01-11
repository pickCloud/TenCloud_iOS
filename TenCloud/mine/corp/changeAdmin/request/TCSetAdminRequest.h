//
//  TCSetAdminRequest.h
//  功能:设置管理员
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCSetAdminRequest : YTKRequest

@property (nonatomic, assign)   NSInteger    uid;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
