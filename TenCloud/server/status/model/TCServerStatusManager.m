//
//  TCServerStatusManager.m
//  TenCloud
//
//  Created by huangdx on 2018/3/21.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerStatusManager.h"

@interface TCServerStatusManager()
@property (nonatomic, strong)   NSMutableArray  *mStatusArray;
- (TCServerStatus*) statusForServerID:(NSInteger)serverID;

@end

@implementation TCServerStatusManager

+ (instancetype) shared
{
    static TCServerStatusManager *instance;
    static dispatch_once_t statusDisp;
    dispatch_once(&statusDisp, ^{
        instance = [[TCServerStatusManager alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _mStatusArray = [NSMutableArray new];
    }
    return self;
}

- (void) rebootWithServerID:(NSInteger)serverID
{
    TCServerStatus *curStatus = [self statusForServerID:serverID];
    if (curStatus == nil)
    {
        curStatus = [TCServerStatus new];
        curStatus.serverID = serverID;
    }
    [curStatus reboot];
}

- (void) startWithServerID:(NSInteger)serverID
{
    TCServerStatus *curStatus = [self statusForServerID:serverID];
    if (curStatus == nil)
    {
        curStatus = [TCServerStatus new];
        curStatus.serverID = serverID;
    }
    [curStatus start];
}

- (void) stopWithServerID:(NSInteger)serverID
{
    TCServerStatus *curStatus = [self statusForServerID:serverID];
    if (curStatus == nil)
    {
        curStatus = [TCServerStatus new];
        curStatus.serverID = serverID;
    }
    [curStatus stop];
}

- (void) addObserver:(id<TCServerStatusDelegate>)obs withServerID:(NSInteger)serverID
{
    if (obs)
    {
        TCServerStatus *curStatus = [self statusForServerID:serverID];
        if (curStatus == nil)
        {
            curStatus = [TCServerStatus new];
            curStatus.serverID = serverID;
        }
        [curStatus addObserver:obs];
    }
}

- (void) removeObserver:(id<TCServerStatusDelegate>)obs withServerID:(NSInteger)serverID
{
    if (obs)
    {
        TCServerStatus *curStatus = [self statusForServerID:serverID];
        if (curStatus)
        {
            [curStatus removeObserver:obs];
        }
    }
}

- (TCServerStatus*) statusForServerID:(NSInteger)serverID
{
    for (TCServerStatus *tmpStatus in _mStatusArray)
    {
        if (tmpStatus.serverID == serverID)
        {
            return tmpStatus;
        }
    }
    return nil;
}
@end
