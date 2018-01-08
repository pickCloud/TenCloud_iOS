//
//  TCButtonTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2018/1/7.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCProfileButtonData.h"

@class TCButtonTableViewCell;
typedef void (^TCButtonCellTouchedBlock)(TCButtonTableViewCell *cell, NSInteger cellIndex);

@interface TCButtonTableViewCell : UITableViewCell

@property (nonatomic, copy) TCButtonCellTouchedBlock    touchedBlock;

- (void) setData:(TCProfileButtonData*)data;

@end
