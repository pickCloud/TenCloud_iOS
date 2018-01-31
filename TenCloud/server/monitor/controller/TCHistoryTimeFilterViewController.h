//
//  TCHistoryTimeFilterViewController.h
//  TenCloud
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
