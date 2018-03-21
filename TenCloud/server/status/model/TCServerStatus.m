//
//  TCServerStatus.m
//  TenCloud
//
//  Created by huangdx on 2018/3/21.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerStatus.h"
#import "TCServerStatusRequest.h"
#define SERVER_STATUS_MIN_TIMES         10
#define SERVER_STATUS_MAX_TIMES         60
#define SERVER_STATUS_FETCH_INTERVAL    2.0

@interface TCServerStatus()
{
    NSMutableArray      *mObservers;
    NSInteger           times;
    NSTimer             *fetchTimer;
    NSMutableArray      *mStatusArray;
    BOOL                completed;
}
- (void) reset;
- (void) fetchServerStatus;
@end

@implementation TCServerStatus

- (id) init
{
    self = [super init];
    if (self)
    {
        mObservers = [NSMutableArray new];
        mStatusArray = [NSMutableArray new];
    }
    return self;
}

- (void) addObserver:(id<TCServerStatusDelegate>)obs
{
    if (obs)
    {
        [mObservers addObject:obs];
    }
}

- (void) removeObserver:(id<TCServerStatusDelegate>)obs
{
    if (obs)
    {
        [mObservers removeObject:obs];
    }
}

- (void) reset
{
    [mStatusArray removeAllObjects];
    completed = NO;
    times = 0;
    if (fetchTimer)
    {
        [fetchTimer invalidate];
        fetchTimer = nil;
    }
}

- (void) fetchServerStatus
{
    if (times >= SERVER_STATUS_MAX_TIMES)
    {
        if (fetchTimer)
        {
            [fetchTimer invalidate];
            fetchTimer = nil;
        }
        NSLog(@"次数达到停止%ld: %ld",times,_actionType);
    }else
    {
        NSLog(@"fetch status%ld: %ld",times,_actionType);
    }
    __weak __typeof(self) weakSelf = self;
    NSString *idStr = [NSString stringWithFormat:@"%ld",_serverID];
    TCServerStatusRequest *req = [[TCServerStatusRequest alloc] initWithInstanceID:idStr];
    [req startWithSuccess:^(NSString *status) {
        weakSelf.status = status;
    } failure:^(NSString *message) {
        
    }];
    times ++;
}

- (void) setStatus:(NSString *)status
{
    if (![_status isEqualToString:status])
    {
        _status = status;
        for (id<TCServerStatusDelegate> obs in mObservers)
        {
            if (obs && [obs respondsToSelector:@selector(serverWithID:statusChanged:)])
            {
                [obs serverWithID:_serverID statusChanged:_status];
            }
        }
    }
}

- (void) reboot
{
    NSLog(@"serverStatus重启啦");
    [self reset];
    _actionType = TCServerActionReboot;
    if (fetchTimer == nil)
    {
        [self fetchServerStatus];
        fetchTimer = [NSTimer scheduledTimerWithTimeInterval:SERVER_STATUS_FETCH_INTERVAL
                                                      target:self
                                                    selector:@selector(fetchServerStatus)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void) start
{
    NSLog(@"serverStatus开机啦");
    [self reset];
    _actionType = TCServerActionStart;
    if (fetchTimer == nil)
    {
        [self fetchServerStatus];
        fetchTimer = [NSTimer scheduledTimerWithTimeInterval:SERVER_STATUS_FETCH_INTERVAL
                                                      target:self
                                                    selector:@selector(fetchServerStatus)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void) stop
{
    NSLog(@"serverStatus关机啦");
    [self reset];
    _actionType = TCServerActionStop;
    if (fetchTimer == nil)
    {
        [self fetchServerStatus];
        fetchTimer = [NSTimer scheduledTimerWithTimeInterval:SERVER_STATUS_FETCH_INTERVAL
                                                      target:self
                                                    selector:@selector(fetchServerStatus)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


@end
