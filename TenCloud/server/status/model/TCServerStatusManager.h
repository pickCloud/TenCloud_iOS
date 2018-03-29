//
//  TCServerStatusManager.h
//  功能:服务器重启、开机、关机时，刷新服务器状态，并通知所有地方更新服务器状态
//
//  Created by huangdx on 2018/3/21.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCServerStatus.h"

@interface TCServerStatusManager : NSObject

+ (instancetype) shared;

- (void) rebootWithServerID:(NSInteger)serverID;

- (void) startWithServerID:(NSInteger)serverID;

- (void) stopWithServerID:(NSInteger)serverID;

- (void) addObserver:(id<TCServerStatusDelegate>)obs withServerID:(NSInteger)serverID;

- (void) removeObserver:(id<TCServerStatusDelegate>)obs withServerID:(NSInteger)serverID;

- (BOOL) operationCompletedWithServerID:(NSInteger)serverID;

@end
