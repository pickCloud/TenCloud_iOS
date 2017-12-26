//
//  TCEditTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCellData.h"

@class TCBasicTableViewCell;
typedef void (^TCCellValueChangedBlock)(TCBasicTableViewCell *cell, NSInteger selectedIndex, id newValue);

@interface TCBasicTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController        *fatherViewController;
@property (nonatomic, strong)   TCCellData          *data;
@property (nonatomic, copy) TCCellValueChangedBlock valueChangedBlock;
@property (nonatomic, weak)     IBOutlet            UILabel *nameLabel;
@property (nonatomic, weak)     IBOutlet            UILabel *descLabel;

@end
