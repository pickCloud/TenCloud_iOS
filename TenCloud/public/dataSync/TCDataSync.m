//
//  TCDataSync.m
//  TenCloud
//
//  Created by huangdx on 2018/2/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCDataSync.h"
#import "TCUserPermissionRequest.h"

@interface TCDataSync()
{
    NSMutableArray              *adminObserverArray;
    NSMutableArray              *permissionObserverArray;
}
@end

@implementation TCDataSync

+ (instancetype) shared
{
    static TCDataSync *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCDataSync alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        adminObserverArray = [NSMutableArray new];
        permissionObserverArray = [NSMutableArray new];
    }
    return self;
}

- (void) addAdminChangedObserver:(id<TCDataSyncDelegate>)obs
{
    if (obs)
    {
        [adminObserverArray addObject:obs];
    }
}

- (void) removeAdminChangedObserver:(id<TCDataSyncDelegate>)obs
{
    if (obs)
    {
        [adminObserverArray removeObject:obs];
    }
}

- (void) addPermissionChangedObserver:(id<TCDataSyncDelegate>)obs
{
    if (obs)
    {
        [permissionObserverArray addObject:obs];
    }
}

- (void) removePermissionChangedObserver:(id<TCDataSyncDelegate>)obs
{
    if (obs)
    {
        [permissionObserverArray removeObject:obs];
    }
}

- (void) adminChanged:(BOOL)isAdmin
{
    [[TCCurrentCorp shared] setIsAdmin:isAdmin];
    [self sendPermissionChangedNotification];
}

- (void) permissionChanged
{
    __weak __typeof(self) weakSelf = self;
    NSInteger userID = [[TCLocalAccount shared] userID];
    NSInteger corpID = [[TCCurrentCorp shared] cid];
    TCUserPermissionRequest *permissionReq = [[TCUserPermissionRequest alloc] init];
    permissionReq.userID = userID;
    permissionReq.corpID = corpID;
    [permissionReq startWithSuccess:^(TCTemplate *tmpl) {
        [[TCCurrentCorp shared] setPermissions:tmpl];
        [weakSelf sendPermissionChangedNotification];
    } failure:^(NSString *message,NSInteger errorCode) {
        NSLog(@"get permission failed:%@",message);
    }];
}

- (void) sendAdminChangedNotification
{
    for (id<TCDataSyncDelegate> obs in adminObserverArray)
    {
        if (obs && [obs respondsToSelector:@selector(dataSync:adminChanged:)])
        {
            [obs dataSync:self adminChanged:YES];
        }
    }
}

- (void) sendPermissionChangedNotification
{
    for (id<TCDataSyncDelegate> obs in permissionObserverArray)
    {
        if (obs && [obs respondsToSelector:@selector(dataSync:permissionChanged:)])
        {
            [obs dataSync:self permissionChanged:YES];
        }
    }
}
@end
