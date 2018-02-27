//
//  TCPermissionTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCPermissionTableViewController.h"
#import "TCPermissionNode+CoreDataClass.h"
#import "TCPermissionCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#define PERMISSION_CELL_ID          @"PERMISSION_CELL_ID"

@interface TCPermissionTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak)  TCPermissionNode           *permissionNode;
@property (nonatomic, assign) PermissionVCState         state;
- (TCPermissionNode *) dataForIndexPath:(NSIndexPath*)indexPath;
@end

@implementation TCPermissionTableViewController

- (id) initWithPermissionNode:(TCPermissionNode*)node state:(PermissionVCState)state
{
    self = [super init];
    if (self)
    {
        _permissionNode = node;
        _state = state;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *cellNib = [UINib nibWithNibName:@"TCPermissionCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:PERMISSION_CELL_ID];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _permissionNode.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TCPermissionNode *sectionNode = [_permissionNode.data objectAtIndex:section];
    NSInteger rowAmount = 0;
    rowAmount = sectionNode.subNodeAmount + 1;
    return rowAmount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self) weakSelf = self;
    TCPermissionNode *node = [self dataForIndexPath:indexPath];
    TCPermissionCell *cell = [tableView dequeueReusableCellWithIdentifier:PERMISSION_CELL_ID forIndexPath:indexPath];
    cell.editable = (_state != PermissionVCPreviewPermission);
    [cell setNode:node];
    cell.selectBlock = ^(TCPermissionCell *cell, BOOL selected) {
        [node updateFatherNodeAfterSubNodeChanged];
        [node updateSubNodesAfterFatherNodeChanged];
        [weakSelf.tableView reloadData];
    };
    
    cell.foldBlock = ^(TCPermissionCell *cell, BOOL fold) {
        NSIndexPath *newPath = [weakSelf.tableView indexPathForCell:cell];
        NSMutableArray *pendingUpdatePaths = [NSMutableArray new];
        if (node.data.count > 0)
        {
            node.fold = fold;
            NSInteger cellIndex = newPath.row;
            if (fold)
            {
                for (TCPermissionNode *subItem in node.data)
                {
                    if (!subItem.hidden)
                    {
                        subItem.hidden = fold;
                        cellIndex ++;
                        NSIndexPath *itemPath = [NSIndexPath indexPathForRow:cellIndex inSection:newPath.section];
                        [pendingUpdatePaths addObject:itemPath];
                    }
                    if (subItem.data && subItem.data.count > 0)
                    {
                        for (TCPermissionNode *sn2 in subItem.data)
                        {
                            if (!sn2.hidden)
                            {
                                sn2.hidden = fold;
                                cellIndex ++;
                                NSIndexPath *sn2Path = [NSIndexPath indexPathForRow:cellIndex inSection:newPath.section];
                                [pendingUpdatePaths addObject:sn2Path];
                            }
                        }
                    }
                }
            }else
            {
                for (TCPermissionNode *subItem in node.data)
                {
                    subItem.hidden = fold;
                    cellIndex ++;
                    NSIndexPath *itemPath = [NSIndexPath indexPathForRow:cellIndex inSection:newPath.section];
                    [pendingUpdatePaths addObject:itemPath];
                    if (!subItem.fold)
                    {
                        if (subItem.data && subItem.data.count > 0)
                        {
                            for (TCPermissionNode *sn2 in subItem.data)
                            {
                                sn2.hidden = fold;
                                cellIndex ++;
                                NSIndexPath *sn2Path = [NSIndexPath indexPathForRow:cellIndex inSection:newPath.section];
                                [pendingUpdatePaths addObject:sn2Path];
                            }
                        }
                    }
                }
            }
        
            
            [weakSelf.tableView beginUpdates];
            if (fold)
            {
                [weakSelf.tableView deleteRowsAtIndexPaths:pendingUpdatePaths withRowAnimation:UITableViewRowAnimationFade];
            }else
            {
                [weakSelf.tableView insertRowsAtIndexPaths:pendingUpdatePaths withRowAnimation:UITableViewRowAnimationFade];
            }
            [weakSelf.tableView endUpdates];
        }
    };
    
    return cell;
}

/*
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TCPermissionNode *sectionNode = [_permissionNode.data objectAtIndex:section];
    return sectionNode.name;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - extension
- (TCPermissionNode *) dataForIndexPath:(NSIndexPath*)indexPath
{
    TCPermissionNode *sectionNode = [_permissionNode.data objectAtIndex:indexPath.section];
    return [sectionNode subNodeAtIndex:indexPath.row];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"default_no_data"];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return - TCSCALE(50);
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(13.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"暂无权限" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

@end
