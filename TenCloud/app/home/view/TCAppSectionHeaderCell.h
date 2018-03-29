//
//  TCAppSectionHeaderCell.h
//  TenCloud
//
//  Created by huangdx on 2018/3/27.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCAppSectionHeaderCell;
typedef void (^TCAppSectionHeaderCellBlock)(TCAppSectionHeaderCell *cell);

@interface TCAppSectionHeaderCell : UITableViewCell

@property (nonatomic, copy) TCAppSectionHeaderCellBlock buttonBlock;

- (void) setSectionTitle:(NSString*)title;

- (void) setSectionTitle:(NSString*)title buttonName:(NSString*)name;

@end
