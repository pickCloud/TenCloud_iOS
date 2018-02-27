//
//  TCModifyUserPermissionRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyUserPermissionRequest.h"

@interface TCModifyUserPermissionRequest()

@end

@implementation TCModifyUserPermissionRequest

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSNumber *statusNum = [request.responseJSONObject objectForKey:@"status"];
        if (statusNum && statusNum.integerValue == 10003)
        {
            failure ? failure(@"该员工已离开公司"):nil;
            return ;
        }
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/permission/user/update";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    NSString *funcPermissionStr = [_funcPermissionArray componentsJoinedByString:@","];
    if (funcPermissionStr == nil)
    {
        funcPermissionStr = @"";
    }
    NSString *serverPermissionStr = [_serverPermissionArray componentsJoinedByString:@","];
    if (serverPermissionStr == nil)
    {
        serverPermissionStr = @"";
    }
    NSString *projPermissionStr = [_projectPermissionArray componentsJoinedByString:@","];
    if (projPermissionStr == nil)
    {
        projPermissionStr = @"";
    }
    NSString *filePermissionStr = [_filePermissionArray componentsJoinedByString:@","];
    if (filePermissionStr == nil)
    {
        filePermissionStr = @"";
    }
    NSInteger cid = [[TCCurrentCorp shared] cid];
    return @{@"uid":@(_userID),
             @"cid":@(cid),
             @"permissions":funcPermissionStr,
             @"access_servers":serverPermissionStr,
             @"access_projects":projPermissionStr,
             @"access_filehub":filePermissionStr
             };
}

@end
