//
//  TCModifyUserPermissionRequest.h
//  功能:修改用户权限 网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCModifyUserPermissionRequest : YTKRequest

@property (nonatomic, assign)   NSInteger   userID;
@property (nonatomic, strong)   NSArray     *funcPermissionArray;
@property (nonatomic, strong)   NSArray     *serverPermissionArray;
@property (nonatomic, strong)   NSArray     *projectPermissionArray;
@property (nonatomic, strong)   NSArray     *filePermissionArray;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
