//
//  TCPermissionCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

@class TCPermissionCell;
typedef void (^TCPermissionCellFoldBlock)(TCPermissionCell *cell, BOOL fold);
typedef void (^TCPermissionCellSelectBlock)(TCPermissionCell *cell, BOOL selected);


@class TCPermissionNode;
@interface TCPermissionCell : UITableViewCell

- (void) setNode:(TCPermissionNode *)node;
@property (nonatomic, assign)   BOOL                        editable;
@property (nonatomic, copy) TCPermissionCellFoldBlock       foldBlock;
@property (nonatomic, copy) TCPermissionCellSelectBlock     selectBlock;

@end
