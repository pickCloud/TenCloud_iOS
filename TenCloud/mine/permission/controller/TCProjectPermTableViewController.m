//
//  TCProjectPermTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCProjectPermTableViewController.h"
#import "TCPermissionNode+CoreDataClass.h"
#import "TCProjectPermTableViewCell.h"
//#import "TCFilePermTableViewCell.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#define PROJECT_PERM_CELL_ID          @"PROJECT_PERM_CELL_ID"

@interface TCProjectPermTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak)  TCPermissionNode           *permissionNode;
@property (nonatomic, strong)   NSMutableArray          *serverNodeArray;
@property (nonatomic, assign) PermissionVCState         state;
- (TCPermissionNode *) dataForIndexPath:(NSIndexPath*)indexPath;
- (void) reloadServerNodeArray;
@end

@implementation TCProjectPermTableViewController

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
    _serverNodeArray = [NSMutableArray new];
    [self reloadServerNodeArray];
    
    UINib *cellNib = [UINib nibWithNibName:@"TCProjectPermTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:PROJECT_PERM_CELL_ID];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _serverNodeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self) weakSelf = self;
    TCPermissionNode *node = [_serverNodeArray objectAtIndex:indexPath.row];
    TCProjectPermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROJECT_PERM_CELL_ID forIndexPath:indexPath];
    cell.editable = (_state != PermissionVCPreviewPermission);
    [cell setNode:node];
    cell.selectBlock = ^(TCPermissionCell *cell, BOOL selected) {
        //[node updateFatherNodeAfterSubNodeChanged];
        //[node updateSubNodesAfterFatherNodeChanged];
        //[weakSelf.tableView reloadData];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0;
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

- (void) reloadServerNodeArray
{
    [_serverNodeArray removeAllObjects];
    if (_permissionNode == nil)
    {
        return;
    }
    for (TCPermissionNode *subNode1 in _permissionNode.data)
    {
        if (subNode1.permID > 0) {
            [_serverNodeArray addObject:subNode1];
        }
        for (TCPermissionNode *subNode2 in subNode1.data)
        {
            if (subNode2.permID > 0)
            {
                [_serverNodeArray addObject:subNode2];
            }
            for (TCPermissionNode *subNode3 in subNode2.data)
            {
                if (subNode3.permID > 0)
                {
                    [_serverNodeArray addObject:subNode3];
                }
                for (TCPermissionNode *subNode4 in subNode3.data)
                {
                    if (subNode4.permID > 0)
                    {
                        [_serverNodeArray addObject:subNode4];
                    }
                }
            }
        }
    }
}

#pragma mark - DZNEmptyDataSetSource Methods

 - (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
 {
 return [UIImage imageNamed:@"default_no_data"];
 }

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(13.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"无文件数据" attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return - TCSCALE(50);
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

@end
