//
//  TCUserPermissionRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCUserPermissionRequest.h"
#import "TCPermissionNode+CoreDataClass.h"
#import "TCTemplate+CoreDataClass.h"

@interface TCUserPermissionRequest()

@end

@implementation TCUserPermissionRequest

/*
- (instancetype) initWithCorpID:(NSInteger)cid userID:(NSInteger)uid
{
    self = [super init];
    if (self)
    {
        _corpID = cid;
        _userID = uid;
    }
    return self;
}
 */

- (void) startWithSuccess:(void(^)(TCTemplate *tmpl))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        TCTemplate *tmpl = [self resultTemplate];
        success ? success(tmpl) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:@"/api/permission/%ld/user/%ld/detail/format/%d",_corpID,_userID,1];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (TCTemplate *)resultTemplate
{
    NSDictionary *dataDict = [self.responseJSONObject objectForKey:@"data"];
    TCTemplate *tmpl = [TCTemplate MR_createEntity];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *serverArray = [dataDict objectForKey:@"access_servers"];
    if (serverArray)
    {
        NSMutableArray *serverIDArray = [NSMutableArray new];
        for (NSDictionary *nodeDict in serverArray)
        {
            NSNumber *sid = [nodeDict objectForKey:@"sid"];
            if (sid)
            {
                [serverIDArray addObject:sid];
            }
        }
        NSString *serverIDStr = [serverIDArray componentsJoinedByString:@","];
        tmpl.access_servers = serverIDStr;
    }
    NSArray *projectArray = [dataDict objectForKey:@"access_projects"];
    if (projectArray)
    {
        NSArray *projectNodeArray = [TCPermissionNode mj_objectArrayWithKeyValuesArray:projectArray context:context];
        NSMutableArray *projectIDArray = [NSMutableArray new];
        for (TCPermissionNode *node in projectNodeArray)
        {
            [projectIDArray addObject:@(node.permID)];
        }
        NSString *projectIDStr = [projectIDArray componentsJoinedByString:@","];
        tmpl.access_projects = projectIDStr;
    }
    NSArray *fileArray = [dataDict objectForKey:@"access_filehub"];
    if (fileArray)
    {
        NSArray *fileNodeArray = [TCPermissionNode mj_objectArrayWithKeyValuesArray:fileArray context:context];
        NSMutableArray *fileIDArray = [NSMutableArray new];
        for (TCPermissionNode *node in fileNodeArray)
        {
            [fileIDArray addObject:@(node.permID)];
        }
        NSString *fileIDStr = [fileIDArray componentsJoinedByString:@","];
        tmpl.access_filehub = fileIDStr;
    }
    NSArray *funcArray = [dataDict objectForKey:@"permissions"];
    if (funcArray)
    {
        NSArray *funcNodeArray = [TCPermissionNode mj_objectArrayWithKeyValuesArray:funcArray context:context];
        NSMutableArray *funcIDArray = [NSMutableArray new];
        for (TCPermissionNode *node in funcNodeArray)
        {
            [funcIDArray addObject:@(node.permID)];
        }
        NSString *funcIDStr = [funcIDArray componentsJoinedByString:@","];
        tmpl.permissions = funcIDStr;
    }
    //NSLog(@"tmpl_servers:%@",tmpl.access_servers);
    //NSLog(@"tmpl_projs:%@",tmpl.access_projects);
    //NSLog(@"tmpl_files:%@",tmpl.access_filehub);
    //NSLog(@"tmpl_pers:%@",tmpl.permissions);
    return tmpl;
}
/*
- (id)requestArgument
{
    return nil;
}
 */

@end
