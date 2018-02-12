//
//  TCServerPermTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerPermTableViewController.h"
#import "TCPermissionNode+CoreDataClass.h"
#import "TCServerPermTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TCClusterProvider+CoreDataClass.h"
#import "TCSearchFilterViewController.h"
#define SERVER_PERM_CELL_ID          @"SERVER_PERM_CELL_ID"

@interface TCServerPermTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak)  TCPermissionNode           *permissionNode;
@property (nonatomic, strong)   NSMutableArray          *serverNodeArray;
@property (nonatomic, assign) PermissionVCState         state;
@property (nonatomic, strong)   NSMutableArray          *providers;
@property (nonatomic, strong)   NSMutableArray          *regions;
- (TCPermissionNode *) dataForIndexPath:(NSIndexPath*)indexPath;
- (void) reloadServerNodeArray;
- (void) onFilterNotification:(NSNotification*)sender;
- (IBAction) onFilterButton:(id)sender;
@end

@implementation TCServerPermTableViewController

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
    _providers = [NSMutableArray new];
    _regions = [NSMutableArray new];
    [self reloadServerNodeArray];
    
    UINib *cellNib = [UINib nibWithNibName:@"TCServerPermTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:SERVER_PERM_CELL_ID];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFilterNotification:)
                                                 name:NOTIFICATION_DO_SEARCH
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    //__weak __typeof(self) weakSelf = self;
    TCPermissionNode *node = [_serverNodeArray objectAtIndex:indexPath.row];
    TCServerPermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_PERM_CELL_ID forIndexPath:indexPath];
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
    return 32.0;
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
    BOOL isViewState = _state == PermissionVCPreviewPermission;
    NSLog(@"is view state:%ld",isViewState);
    for (TCPermissionNode *subNode1 in _permissionNode.data)
    {
        if (_providers.count > 0)
        {
            if (![_providers containsObject:subNode1.name]) {
                continue;
            }
        }
        if (subNode1.sid > 0)
        {
            if ((isViewState && subNode1.selected) || !isViewState)
            {
                [_serverNodeArray addObject:subNode1];
            }
        }
        for (TCPermissionNode *subNode2 in subNode1.data)
        {
            if (_regions.count > 0)
            {
                if (![_regions containsObject:subNode2.name])
                {
                    continue;
                }
            }
            if (subNode2.sid > 0)
            {
                if ((isViewState && subNode2.selected) || !isViewState)
                {
                   [_serverNodeArray addObject:subNode2];
                }
            }
            for (TCPermissionNode *subNode3 in subNode2.data)
            {
                if (subNode3.sid > 0)
                {
                    if ((isViewState && subNode3.selected) || !isViewState)
                    {
                        [_serverNodeArray addObject:subNode3];
                    }
                }
                for (TCPermissionNode *subNode4 in subNode3.data)
                {
                    if (subNode4.sid > 0)
                    {
                        if ((isViewState && subNode4.selected) || !isViewState)
                        {
                            [_serverNodeArray addObject:subNode4];
                        }
                    }
                }
            }
        }
    }
}

- (void) onFilterNotification:(NSNotification*)sender
{
    NSDictionary *filterDict = sender.object;
    NSArray *providers = [filterDict objectForKey:@"provider"];
    NSArray *regions = [filterDict objectForKey:@"region"];
    [_providers removeAllObjects];
    [_providers addObjectsFromArray:providers];
    [_regions removeAllObjects];
    [_regions addObjectsFromArray:regions];
    [self reloadServerNodeArray];
    [self.tableView reloadData];
    
}

- (IBAction) onFilterButton:(id)sender
{
    NSMutableArray *providerArr = [NSMutableArray new];
    for (TCPermissionNode *subNode1 in _permissionNode.data)
    {
        TCClusterProvider *provider = [TCClusterProvider MR_createEntity];
        provider.provider = subNode1.name;
        NSMutableArray *regions = [NSMutableArray new];
        for (TCPermissionNode *subNode2 in subNode1.data)
        {
            [regions addObject:subNode2.name];
        }
        provider.regions = regions;
        [providerArr addObject:provider];
    }
    TCSearchFilterViewController *filterVC = [[TCSearchFilterViewController alloc] initWithProviderArray:providerArr];
    [self presentViewController:filterVC animated:NO completion:nil];
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
    return [[NSAttributedString alloc] initWithString:@"无服务器数据" attributes:attributes];
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
