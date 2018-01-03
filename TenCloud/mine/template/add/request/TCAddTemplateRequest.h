//
//  TCAddTemplateRequest.h
//  功能:添加权限模版网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCAddTemplateRequest : YTKRequest

- (instancetype) initWithName:(NSString *)name
                  permissions:(NSArray *)permissionArray
            serverPermissions:(NSArray *)serverPermissions
           projectPermissions:(NSArray *)projectPermissions
              filePermissions:(NSArray *)filePermissions;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
