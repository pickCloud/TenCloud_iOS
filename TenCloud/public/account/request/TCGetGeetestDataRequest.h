//
//  TCGetGeetestDataRequest.h
//  功能:获取极验证数据
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCGetGeetestDataRequest : YTKRequest

//- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber;

- (void) startWithSuccess:(void(^)(NSString *gt, NSString *challenge))success
                  failure:(void(^)(NSString *message))failure;

@end
