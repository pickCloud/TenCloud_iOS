//
//  TCStaffTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/4.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCStaffTableViewController.h"
#import "TCStaffListRequest.h"
#import "TCStaffTableViewCell.h"
#import "TCStaffProfileViewController.h"
#import "TCJoinSettingViewController.h"
#import "FEPopupMenuController.h"
#define STAFF_CELL_ID       @"STAFF_CELL_ID"

@interface TCStaffTableViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *staffArray;
@property (nonatomic, strong)   FEPopupMenuController   *menuController;
- (void) onAddButton:(id)sender;
- (void) reloadStaffArray;
@end

@implementation TCStaffTableViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工列表";
    _staffArray = [NSMutableArray new];
    
    UIImage *addServerImg = [UIImage imageNamed:@"corp_nav_add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addServerImg forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    
    __weak __typeof(self) weakSelf = self;
    FEPopupMenuItem *item1 = [[FEPopupMenuItem alloc] initWithTitle:@"设置个人加入条件" iconImage:nil action:^{
        TCJoinSettingViewController *joinVC = [TCJoinSettingViewController new];
        [weakSelf.navigationController pushViewController:joinVC animated:YES];
    }];
    item1.titleColor = THEME_TEXT_COLOR;
    FEPopupMenuItem *item2 = [[FEPopupMenuItem alloc] initWithTitle:@"邀请员工" iconImage:nil action:^{
        NSLog(@"selected item1...");
    }];
    item2.titleColor = THEME_TEXT_COLOR;
    FEPopupMenuItem *item3 = [[FEPopupMenuItem alloc] initWithTitle:@"更换管理员" iconImage:nil action:^{
        NSLog(@"selected item1...");
    }];
    item3.titleColor = THEME_TEXT_COLOR;
    self.menuController = [[FEPopupMenuController alloc] initWithItems:@[item1,item2,item3]];
    self.menuController.isShowArrow = NO;
    self.menuController.contentViewWidth = 180;
    self.menuController.contentViewBackgroundColor = THEME_NAVBAR_TITLE_COLOR;
    self.menuController.itemSeparatorLineColor = TABLE_CELL_BG_COLOR;
    self.menuController.contentViewCornerRadius = TCSCALE(4.0);
    
    UINib *cellNib = [UINib nibWithNibName:@"TCStaffTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:STAFF_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    
    [self startLoading];
    [self reloadStaffArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadStaffArray
{
    __weak  __typeof(self) weakSelf = self;
    TCStaffListRequest *req = [[TCStaffListRequest alloc] init];
    [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
        [weakSelf.staffArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.staffArray addObjectsFromArray:staffArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
}

#pragma mark - extension
- (void) onAddButton:(id)sender
{
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat posY = navBarRect.origin.y + navBarRect.size.height;
    CGFloat posX = navBarRect.size.width - self.menuController.contentViewWidth - 20;
    CGPoint pos = CGPointMake(posX, posY);
    [self.menuController showInViewController:self atPosition:pos];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _staffArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCStaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STAFF_CELL_ID forIndexPath:indexPath];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    [cell setStaff:staff];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    TCStaffProfileViewController *profileVC = [[TCStaffProfileViewController alloc] initWithStaff:staff];
    [self.navigationController pushViewController:profileVC animated:YES];
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
    return [[NSAttributedString alloc] initWithString:@"无员工记录" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}
@end
