//
//  TCServerHomeUsageCell.h
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCServerUsage;
@interface TCServerHomeUsageCell : UITableViewCell

@property (nonatomic, strong)   UINavigationController  *navController;

- (void) setUsageData:(NSArray<TCServerUsage*> *)usageArray;

@end
