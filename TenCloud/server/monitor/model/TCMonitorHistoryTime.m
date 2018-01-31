//
//  TCMonitorHistoryTime.m
//  TenCloud
//
//  Created by huangdx on 2018/1/31.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCMonitorHistoryTime.h"

@implementation TCMonitorHistoryTime

+ (instancetype) shared
{
    static TCMonitorHistoryTime *instance;
    static dispatch_once_t timeDisp;
    dispatch_once(&timeDisp, ^{
        instance = [[TCMonitorHistoryTime alloc] init];
    });
    return instance;
}

- (void) reset
{
    _startTime = 0;
    _endTime = 0;
}

- (BOOL) isSetted
{
    BOOL setted = _startTime > 0 || _endTime > 0;
    return setted;
}
@end
