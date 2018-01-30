//
//  TCMonitorHistoryTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCPerformanceItem;
@interface TCMonitorHistoryTableViewCell : UITableViewCell

- (void) setPerformance:(TCPerformanceItem*)performance;

@end
