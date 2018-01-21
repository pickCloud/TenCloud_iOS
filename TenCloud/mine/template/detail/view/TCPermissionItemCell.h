//
//  TCPermissionItemCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

@class TCPermissionItemCell;
typedef void (^TCPermissionCellSelectBlock)(TCPermissionItemCell *cell, BOOL selected);

@class TCPermissionNode;
@interface TCPermissionItemCell : UITableViewCell

- (void) setNode:(TCPermissionNode*)node;

@property (nonatomic, copy) TCPermissionCellSelectBlock selectBlock;

@end
