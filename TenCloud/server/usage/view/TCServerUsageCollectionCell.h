//
//  TCServerUsageCollectionCell.h
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCServerUsageCollectionCell;
typedef void (^TCServerUsageCellNextBlock)(TCServerUsageCollectionCell *cell);

@class TCServerUsage;
@interface TCServerUsageCollectionCell : UICollectionViewCell

@property (nonatomic, strong)   TCServerUsage           *usage;
@property (nonatomic, weak)     IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak)     IBOutlet    UIView      *maskView;
@property (nonatomic, weak)     IBOutlet    UIView      *highlightView;
@property (nonatomic, weak)     IBOutlet    UILabel     *cpuLabel;
@property (nonatomic, weak)     IBOutlet    UILabel     *memoryLabel;
@property (nonatomic, weak)     IBOutlet    UILabel     *diskLabel;
@property (nonatomic, weak)     IBOutlet    UILabel     *networkLabel;

@property (nonatomic, weak)     IBOutlet    UILabel     *row1Label;
@property (nonatomic, weak)     IBOutlet    UILabel     *row2Label;
@property (nonatomic, weak)     IBOutlet    UILabel     *row3Label;
@property (nonatomic, weak)     IBOutlet    UILabel     *row4Label;
@property (nonatomic, weak)     IBOutlet    UILabel     *row5Label;

@property (nonatomic, copy) TCServerUsageCellNextBlock  nextBlock;

- (void) setUsage:(TCServerUsage*)usage;

- (void) highlight;

- (void) unhighlight;

- (NSArray*) usageParamArray;

@end
