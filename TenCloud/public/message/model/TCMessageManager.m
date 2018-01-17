//
//  TCMessageManager.m
//  TenCloud
//
//  Created by huangdx on 2018/1/17.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCMessageManager.h"
#import "TCMessageCountRequest.h"

@interface TCMessageManager()
{
    NSMutableArray              *mObserverArray;
}
@property (nonatomic, strong)   NSTimer     *updateTimer;
- (void) fetchMessageCount;
- (void) sendMessageCount:(NSInteger)count;
@end

@implementation TCMessageManager

+ (instancetype) shared
{
    static TCMessageManager *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCMessageManager alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        mObserverArray = [NSMutableArray new];
    }
    return self;
}

- (void) start
{
    if ([[TCLocalAccount shared] isLogin])
    {
        if (_updateTimer)
        {
            [_updateTimer invalidate];
            _updateTimer = nil;
        }
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchMessageCount) userInfo:nil repeats:YES];
        //[self fetchMessageCount];
        [self performSelector:@selector(fetchMessageCount) withObject:nil afterDelay:0.6];
    }
}

- (void) stop
{
    if (_updateTimer)
    {
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
}

- (void) clearMessageCount
{
    _count = 0;
    [self sendMessageCount:_count];
}

- (void) fetchMessageCount
{
    __weak __typeof(self) weakSelf = self;
    TCMessageCountRequest *countReq = [TCMessageCountRequest new];
    [countReq startWithSuccess:^(NSInteger count) {
        weakSelf.count = count;
        [weakSelf sendMessageCount:count];
    } failure:^(NSString *message) {
        NSLog(@"fetch message count error:%@",message);
    }];
}

- (void) addObserver:(id<TCMessageManagerDelegate>)obs
{
    if (obs)
    {
        [mObserverArray addObject:obs];
        NSLog(@"add obs arry:%@",mObserverArray);
    }
}

- (void) removeObserver:(id<TCMessageManagerDelegate>)obs
{
    if (obs)
    {
        [mObserverArray addObject:obs];
    }
}

- (void) sendMessageCount:(NSInteger)count
{
    for (id<TCMessageManagerDelegate> obs in mObserverArray)
    {
        if ([obs respondsToSelector:@selector(messageCountChanged:)])
        {
            [obs messageCountChanged:count];
        }
    }
}
@end
