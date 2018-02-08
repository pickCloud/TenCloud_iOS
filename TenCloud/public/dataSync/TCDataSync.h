//
//  TCDataSync.h
//  TenCloud
//
//  Created by huangdx on 2018/2/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCDataSync;
@protocol TCDataSyncDelegate <NSObject>
@optional
- (void) dataSync:(TCDataSync*)sync adminChanged:(BOOL)changed;
- (void) dataSync:(TCDataSync*)sync permissionChanged:(NSInteger)changed;
@end

@interface TCDataSync : NSObject

+ (instancetype) shared;

- (void) addAdminChangedObserver:(id<TCDataSyncDelegate>)obs;
- (void) removeAdminChangedObserver:(id<TCDataSyncDelegate>)obs;

- (void) addPermissionChangedObserver:(id<TCDataSyncDelegate>)obs;
- (void) removePermissionChangedObserver:(id<TCDataSyncDelegate>)obs;

- (void) adminChanged:(BOOL)isAdmin;
- (void) permissionChanged;

- (void) sendAdminChangedNotification;
- (void) sendPermissionChangedNotification;

@end
