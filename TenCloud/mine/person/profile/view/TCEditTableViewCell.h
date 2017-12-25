//
//  TCEditTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCEditCellData.h"

@class TCEditTableViewCell;
typedef void (^TCCellValueChangedBlock)(TCEditTableViewCell *cell, NSInteger selectedIndex, id newValue);

@interface TCEditTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController        *fatherViewController;
@property (nonatomic, strong)   TCEditCellData      *data;
@property (nonatomic, copy) TCCellValueChangedBlock valueChangedBlock;
@property (nonatomic, weak)     IBOutlet            UILabel *nameLabel;
@property (nonatomic, weak)     IBOutlet            UILabel *descLabel;

@end
