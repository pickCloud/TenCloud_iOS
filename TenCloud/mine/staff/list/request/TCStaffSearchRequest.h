//
//  TCStaffSearchRequest.h
//  功能:员工搜索请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

//@class TCServer;
@class TCStaff;
@interface TCStaffSearchRequest : YTKRequest

/*
- (instancetype) initWithServerName:(NSString*)name
                            regions:(NSArray*)regions
                          providers:(NSArray*)providers;
 */
@property (nonatomic, strong)   NSString    *keyword;
@property (nonatomic, assign)   NSInteger   status;

- (void) startWithSuccess:(void(^)(NSArray<TCStaff*> *staffArray))success
                  failure:(void(^)(NSString *message))failure;

@end
