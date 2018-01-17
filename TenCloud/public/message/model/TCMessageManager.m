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
@property (nonatomic, strong)   NSTimer     *updateTimer;
- (void) fetchMessageCount;
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
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(fetchMessageCount) userInfo:nil repeats:YES];
    }
    return self;
}

- (void) start
{
    
}

- (void) fetchMessageCount
{
    TCMessageCountRequest *countReq = [TCMessageCountRequest new];
    [countReq startWithSuccess:^(NSInteger count) {
        
    } failure:^(NSString *message) {
        NSLog(@"fetch message count error:%@",message);
    }];
}
@end
