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
#define PERMISSION_HEADER_CELL_ID   @"PERMISSION_HEADER_CELL_ID"
#define PERMISSION_CELL_ID          @"PERMISSION_CELL_ID"

@interface TCPermissionTableViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak)  TCPermissionNode           *permissionNode;
- (TCPermissionNode *) dataForIndexPath:(NSIndexPath*)indexPath;
@end

@implementation TCPermissionTableViewController

- (id) initWithPermissionNode:(TCPermissionNode*)node
{
    self = [super init];
    if (self)
    {
        _permissionNode = node;
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
    
    /*
    if (!node.data || node.data.count == 0)
    {
        TCPermissionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:PERMISSION_ITEM_CELL_ID forIndexPath:indexPath];
        [cell setNode:node];
        cell.selectBlock = ^(TCPermissionItemCell *cell, BOOL selected) {
            NSLog(@"itm cell selected:%d",selected);
            TCPermissionNode *fatherNode = node.fatherNode;
            //NSLog(@"fatherNode:%@",fatherNode);
            BOOL newValue = YES;
            for (TCPermissionNode *subNode in fatherNode.data)
            {
                newValue &= subNode.selected;
                NSLog(@"node name:%@ s:%d",subNode.name,subNode.selected);
            }
            fatherNode.selected = newValue;
            NSLog(@"father node:%d",fatherNode.selected);
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
    TCPermissionFoldCell *cell = [tableView dequeueReusableCellWithIdentifier:PERMISSION_FOLD_CELL_ID forIndexPath:indexPath];
    [cell setNode:node];
    cell.selectBlock = ^(TCPermissionItemCell *cell, BOOL selected) {
        if (node.data.count > 0)
        {
            for (TCPermissionNode *subNode in node.data)
            {
                subNode.selected = selected;
            }
            [weakSelf.tableView reloadData];
        }
    };
    cell.foldBlock = ^(TCPermissionFoldCell *cell, BOOL fold) {
        if (node.data.count > 0)
        {
            node.fold = fold;
            for (TCPermissionNode *subItem in node.data)
            {
                subItem.hidden = fold;
            }
            [weakSelf.tableView reloadData];
        }
    };
    return cell;
     */
    
    
    /*
    __weak __typeof(self) weakSelf = self;
    TCPermissionObject *obj = [self dataForIndexPath:indexPath];
    if (obj && [obj isKindOfClass:[TCPermissionItem class]])
    {
        TCPermissionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:PERMISSION_ITEM_CELL_ID forIndexPath:indexPath];
        TCPermissionItem *item = (TCPermissionItem*)obj;
        [cell setItem:item];
        cell.selectBlock = ^(TCPermissionItemCell *cell, BOOL selected) {
            TCPermissionChunk *fatherItem = item.fatherItem;
            BOOL newValue = YES;
            for (TCPermissionItem *subItem in fatherItem.data)
            {
                newValue &= subItem.selected;
            }
            fatherItem.selected = newValue;
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
    TCPermissionFoldCell *cell = [tableView dequeueReusableCellWithIdentifier:PERMISSION_FOLD_CELL_ID forIndexPath:indexPath];
    TCPermissionChunk *chunk = (TCPermissionChunk*)obj;
    [cell setChunk:chunk];
    cell.selectBlock = ^(TCPermissionItemCell *cell, BOOL selected) {
        
        if (chunk.data.count > 0)
        {
            for (TCPermissionItem *subItem in chunk.data)
            {
                subItem.selected = selected;
            }
            [weakSelf.tableView reloadData];
        }
    };
    cell.foldBlock = ^(TCPermissionFoldCell *cell, BOOL fold) {
        if (chunk.data.count > 0)
        {
            chunk.fold = fold;
            for (TCPermissionItem *subItem in chunk.data)
            {
                subItem.hidden = fold;
            }
            [weakSelf.tableView reloadData];
        }
    };
    return cell;
     */
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
    if (indexPath.row == 0)
    {
    //return sectionNode;
    }
    return [sectionNode subNodeAtIndex:indexPath.row];
}

@end
