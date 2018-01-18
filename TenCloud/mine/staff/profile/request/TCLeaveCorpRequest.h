//
//  TCLeaveCorpRequest.h
//  功能:员工离开企业
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCLeaveCorpRequest : YTKRequest

@property (nonatomic, assign)   NSInteger    staffID;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
