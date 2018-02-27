//
//  TCModifyPermissionRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyPermissionRequest.h"

@interface TCModifyPermissionRequest()

@end

@implementation TCModifyPermissionRequest

- (instancetype) initWithTemplateID:(NSInteger)tid
                               name:(NSString*)name
                funcPermissionArray:(NSArray*)funcPerArray
              serverPermissionArray:(NSArray*)serverPerArray
             projectPermissionArray:(NSArray*)projPerArray
                filePermissionArray:(NSArray*)filePerArray
{
    self = [super init];
    if (self)
    {
        _templateID = tid;
        _name = name;
        _funcPermissionArray = funcPerArray;
        _serverPermissionArray = serverPerArray;
        _projectPermissionArray = projPerArray;
        _filePermissionArray = filePerArray;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        success ? success(@"修改成功"):nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/permission/template/%ld/update",_templateID];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPUT;
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
    return @{@"pt_id":@(_templateID),
             @"cid":@(cid),
             @"name":_name,
             @"permissions":funcPermissionStr,
             @"access_servers":serverPermissionStr,
             @"access_projects":projPermissionStr,
             @"access_filehub":filePermissionStr
             };
}

@end
