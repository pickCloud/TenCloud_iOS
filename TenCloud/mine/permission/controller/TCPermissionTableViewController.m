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
#import "TCPermissionSectionHeaderCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#define PERMISSION_HEADER_CELL_ID   @"PERMISSION_HEADER_CELL_ID"
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
    // Do any additional setup after loading the view from its nib.
    UINib *headerCellNib = [UINib nibWithNibName:@"TCPermissionSectionHeaderCell" bundle:nil];
    [_tableView registerNib:headerCellNib forCellReuseIdentifier:PERMISSION_HEADER_CELL_ID];
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
    rowAmount = sectionNode.subNodeAmount;
    NSLog(@"s%ld row amount:%ld",section, rowAmount);
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
        if (node.data.count > 0)
        {
            node.fold = fold;
            for (TCPermissionNode *subItem in node.data)
            {
                subItem.hidden = fold;
            }
        }
        [weakSelf.tableView reloadData];
    };
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TCPermissionNode *sectionNode = [_permissionNode.data objectAtIndex:section];
    return sectionNode.name;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    /*
    TCPermissionSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:PERMISSION_HEADER_CELL_ID];
    TCPermissionSection *pSection = [_permissionSegment.data objectAtIndex:section];
    headerCell.nameLabel.text = pSection.name;
    return headerCell;
     */
    TCPermissionSectionHeaderCell *headerCell = [[[NSBundle mainBundle] loadNibNamed:@"TCPermissionSectionHeaderCell" owner:nil options:nil] lastObject];
    TCPermissionNode *sectionNode = [_permissionNode.data objectAtIndex:section];
    headerCell.nameLabel.text = sectionNode.name;
    return headerCell;
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
/*
 - (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
 {
 return [UIImage imageNamed:@"no_data"];
 }
 */

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
