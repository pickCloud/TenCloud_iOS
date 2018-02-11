//
//  TCAddTemplateRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddTemplateRequest.h"

@interface TCAddTemplateRequest()
@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSArray     *permissions;
@property (nonatomic, strong)   NSArray     *serverPermissions;
@property (nonatomic, strong)   NSArray     *projectPermissions;
@property (nonatomic, strong)   NSArray     *filePermissions;
@end

@implementation TCAddTemplateRequest

- (instancetype) initWithName:(NSString *)name
                  permissions:(NSArray *)permissionArray
            serverPermissions:(NSArray *)serverPermissions
           projectPermissions:(NSArray *)projectPermissions
              filePermissions:(NSArray *)filePermissions
{
    self = [super init];
    if (self)
    {
        _name = name;
        _permissions = permissionArray;
        _serverPermissions = serverPermissions;
        _projectPermissions = projectPermissions;
        _filePermissions = filePermissions;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            //NSNumber *cidNum = [dataDict objectForKey:@"cid"];
        }
        success ? success (@"添加成功") : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/permission/template/add";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    NSString *permissionStr = [_permissions componentsJoinedByString:@","];
    if (permissionStr == nil)
    {
        permissionStr = @"";
    }
    NSString *serverPermissionStr = [_serverPermissions componentsJoinedByString:@","];
    if (serverPermissionStr == nil)
    {
        serverPermissionStr = @"";
    }
    NSString *projPermissionStr = [_projectPermissions componentsJoinedByString:@","];
    if (projPermissionStr == nil)
    {
        projPermissionStr = @"";
    }
    NSString *filePermissionStr = [_filePermissions componentsJoinedByString:@","];
    if (filePermissionStr == nil)
    {
        filePermissionStr = @"";
    }
    
    NSInteger cid = [[TCCurrentCorp shared] cid];
    return @{@"name":_name,
             @"cid":@(cid),
             @"permissions":permissionStr,
             @"access_servers":serverPermissionStr,
             @"access_projects":projPermissionStr,
             @"access_filehub":filePermissionStr
             };
}

@end
