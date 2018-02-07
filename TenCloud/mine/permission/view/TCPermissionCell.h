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

@property (nonatomic, weak)     TCPermissionNode        *mNode;
@property (nonatomic, assign)   BOOL                        editable;
@property (nonatomic, copy) TCPermissionCellFoldBlock       foldBlock;
@property (nonatomic, copy) TCPermissionCellSelectBlock     selectBlock;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *checkButton;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *leftConstraint;
- (void) setNode:(TCPermissionNode *)node;
- (void) updateCheckButtonUI;

@end
