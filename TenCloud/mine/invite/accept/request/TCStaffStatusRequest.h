//
//  TCStaffStatusRequest.h
//  功能:员工状态
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCStaffStatusRequest : YTKRequest

- (instancetype) initWithCorpID:(NSInteger)corpID;

- (void) startWithSuccess:(void(^)(NSInteger status))success
                  failure:(void(^)(NSString *message))failure;

@end
