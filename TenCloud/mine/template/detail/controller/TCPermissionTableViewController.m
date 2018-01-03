//
//  TCPermissionTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCPermissionTableViewController.h"
#import "TCPermissionSegment+CoreDataClass.h"
#import "TCPermissionFoldCell.h"
#import "TCPermissionItemCell.h"
#import "TCPermissionSection+CoreDataClass.h"
#import "TCPermissionChunk+CoreDataClass.h"
#import "TCPermissionItem+CoreDataClass.h"
#import "TCPermissionSectionHeaderCell.h"
#define PERMISSION_FOLD_CELL_ID     @"PERMISSION_FOLD_CELL_ID"
#define PERMISSION_HEADER_CELL_ID   @"PERMISSION_HEADER_CELL_ID"
#define PERMISSION_ITEM_CELL_ID     @"PERMISSION_ITEM_CELL_ID"

@interface TCPermissionTableViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) TCPermissionSegment         *permissionSegment;
- (TCPermissionObject *) dataForIndexPath:(NSIndexPath*)indexPath;
@end

@implementation TCPermissionTableViewController

- (id) initWithPermissionSegment:(TCPermissionSegment*)segment
{
    self = [super init];
    if (self)
    {
        _permissionSegment = segment;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *headerCellNib = [UINib nibWithNibName:@"TCPermissionSectionHeaderCell" bundle:nil];
    [_tableView registerNib:headerCellNib forCellReuseIdentifier:PERMISSION_HEADER_CELL_ID];
    UINib *foldCellNib = [UINib nibWithNibName:@"TCPermissionFoldCell" bundle:nil];
    [_tableView registerNib:foldCellNib forCellReuseIdentifier:PERMISSION_FOLD_CELL_ID];
    UINib *itemCellNib = [UINib nibWithNibName:@"TCPermissionItemCell" bundle:nil];
    [_tableView registerNib:itemCellNib forCellReuseIdentifier:PERMISSION_ITEM_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    
    NSLog(@"per seg count:%ld",_permissionSegment.data.count);
    TCPermissionSection *sec0 = [_permissionSegment.data objectAtIndex:0];
    NSLog(@"sec0 count:%ld",sec0.data.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _permissionSegment.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TCPermissionSection *pSection = [_permissionSegment.data objectAtIndex:section];
    NSInteger rowAmount = 0;
    for (TCPermissionChunk *chunk in pSection.data)
    {
        if (chunk.fold == YES)
        {
            rowAmount += 1;
        }else
        {
            rowAmount += (chunk.data.count + 1);
        }
    }
    NSLog(@"section %ld rowAmount:%ld",section, rowAmount);
    return rowAmount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            
            /*
            NSMutableArray *needUpdatePaths = [NSMutableArray new];
            for (int i = 0; i < chunk.data.count; i++)
            {
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:indexPath.row + i + 1  inSection:indexPath.section];
                [needUpdatePaths addObject:newPath];
            }
            [weakSelf.tableView beginUpdates];
            if (fold)
            {
                [weakSelf.tableView deleteRowsAtIndexPaths:needUpdatePaths withRowAnimation:UITableViewRowAnimationFade];
            }else
            {
                [weakSelf.tableView insertRowsAtIndexPaths:needUpdatePaths withRowAnimation:UITableViewRowAnimationFade];
            }
            
            NSMutableArray *headerPaths = [NSMutableArray new];
            for (int i = 0; i < _permissionSegment.data.count; i++)
            {
                NSIndexPath *headerPath = [NSIndexPath indexPathForRow:NSNotFound inSection:i];
                [headerPaths addObject:headerPath];
            }
            [weakSelf.tableView reloadRowsAtIndexPaths:headerPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView endUpdates];
            */
        }
    };
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TCPermissionSection *pSection = [_permissionSegment.data objectAtIndex:section];
    return pSection.name;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    /*
    TCPermissionSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:PERMISSION_HEADER_CELL_ID];
    TCPermissionSection *pSection = [_permissionSegment.data objectAtIndex:section];
    headerCell.nameLabel.text = pSection.name;
    return headerCell;
     */
    TCPermissionSectionHeaderCell *headerCell = [[[NSBundle mainBundle] loadNibNamed:@"TCPermissionSectionHeaderCell" owner:nil options:nil] lastObject];
    TCPermissionSection *pSection = [_permissionSegment.data objectAtIndex:section];
    headerCell.nameLabel.text = pSection.name;
    return headerCell;
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - extension
- (TCPermissionObject *) dataForIndexPath:(NSIndexPath*)indexPath
{
    TCPermissionSection *pSection = [_permissionSegment.data objectAtIndex:indexPath.section];
    TCPermissionObject *obj = nil;
    int objIndex = 0;
    for (TCPermissionChunk *chunk in pSection.data)
    {
        if (objIndex == indexPath.row)
        {
            return chunk;
        }
        if (chunk.hidden == NO)
        {
            objIndex ++;
        }
        for (TCPermissionItem *item in chunk.data)
        {
            if (objIndex == indexPath.row)
            {
                return item;
            }
            if (item.hidden == NO)
            {
                objIndex ++;
            }
        }
    }
    return obj;
    //TCPermissionChunk *chunk0 = [pSection.data objectAtIndex:indexPath.row];
    
}

@end
