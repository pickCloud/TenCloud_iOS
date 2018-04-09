//
//  TCCloudListRequest.h
//  功能:获取云列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCCloud;
@interface TCCloudListRequest : YTKRequest

/*
@property (nonatomic, assign)   NSInteger   appID;
@property (nonatomic, assign)   NSInteger   status;
@property (nonatomic, assign)   NSInteger   page;
@property (nonatomic, assign)   NSInteger   page_num;
@property (nonatomic, strong)   NSString    *label;
*/
 
- (NSArray<TCCloud*> *)resultCloudArray;

- (void) startWithSuccess:(void(^)(NSArray<TCCloud*> *cloudArray))success
                  failure:(void(^)(NSString *message))failure;

@end
