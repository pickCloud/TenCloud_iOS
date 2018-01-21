//
//  TCPermissionFoldCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

@class TCPermissionFoldCell;
typedef void (^TCPermissionCellFoldBlock)(TCPermissionFoldCell *cell, BOOL fold);
#import "TCPermissionItemCell.h"

@interface TCPermissionFoldCell : TCPermissionItemCell

- (void) setNode:(TCPermissionNode *)node;

@property (nonatomic, copy) TCPermissionCellFoldBlock foldBlock;

@end
