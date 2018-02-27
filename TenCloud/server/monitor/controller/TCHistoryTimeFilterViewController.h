//
//  TCHistoryTimeFilterViewController.h
//  功能:服务器监控历史记录页面中的 时间筛选页面
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCHistoryTimeFilterViewController;
typedef void (^TCHistoryTimeFilterChangedBlock)(TCHistoryTimeFilterViewController *cell);

@interface TCHistoryTimeFilterViewController : UIViewController

@property (nonatomic, copy) TCHistoryTimeFilterChangedBlock valueChangedBlock;

@end
