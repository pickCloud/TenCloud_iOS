//
//  TCStaffListRequest.h
//  功能:获取公司列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

//@class TCListCorp;
@class TCStaff;
@interface TCStaffListRequest : YTKRequest

- (NSArray<TCStaff*> *)resultStaffArray;

- (void) startWithSuccess:(void(^)(NSArray<TCStaff *> *staffArray))success
                  failure:(void(^)(NSString *message))failure;

@end
