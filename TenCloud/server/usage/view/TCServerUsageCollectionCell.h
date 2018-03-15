//
//  TCServerUsageCollectionCell.h
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCServerUsage;
@interface TCServerUsageCollectionCell : UICollectionViewCell

@property (nonatomic, weak)     IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak)     IBOutlet    UIView      *maskView;
@property (nonatomic, weak)     IBOutlet    UIView      *highlightView;
@property (nonatomic, weak)     IBOutlet    UILabel     *cpuLabel;
@property (nonatomic, weak)     IBOutlet    UILabel     *memoryLabel;
@property (nonatomic, weak)     IBOutlet    UILabel     *diskLabel;
@property (nonatomic, weak)     IBOutlet    UILabel     *networkLabel;

- (void) setUsage:(TCServerUsage*)usage;

- (void) highlight;

- (void) unhighlight;

@end
