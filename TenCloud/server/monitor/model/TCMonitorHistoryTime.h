//
//  TCMonitorHistoryTime.h
//  TenCloud
//
//  Created by huangdx on 2018/1/31.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMonitorHistoryTime : NSObject

+ (instancetype) shared;

- (void) reset;

- (BOOL) isSetted;

@property (nonatomic, assign)   NSInteger   startTime;
@property (nonatomic, assign)   NSInteger   endTime;
@end
