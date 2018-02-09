//
//  TCServerContainerTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerContainerTableViewController.h"
#import "TCServerContainerListRequest.h"
#import "TCServerContainerTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#define SERVER_CONTAINER_CELL_REUSE_ID    @"SERVER_CONTAINER_CELL_REUSE_ID"

@interface TCServerContainerTableViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, strong)   NSMutableArray  *containerArray;
@property (nonatomic, weak)     IBOutlet    UITableView     *tableView;
@end

@implementation TCServerContainerTableViewController

- (instancetype) initWithID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _containerArray = [NSMutableArray new];
    UINib *containerCellNib = [UINib nibWithNibName:@"TCServerContainerTableViewCell" bundle:nil];
    [_tableView registerNib:containerCellNib forCellReuseIdentifier:SERVER_CONTAINER_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCServerContainerListRequest *request = [[TCServerContainerListRequest alloc] initWithServerID:_serverID];
    [request startWithSuccess:^(NSArray<NSArray *> *containerArray) {
        [weakSelf stopLoading];
        [weakSelf.containerArray removeAllObjects];
        [weakSelf.containerArray addObjectsFromArray:containerArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
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
    return _containerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerContainerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CONTAINER_CELL_REUSE_ID forIndexPath:indexPath];
    NSArray *strArray = [_containerArray objectAtIndex:indexPath.row];
    [cell setContainer:strArray];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    return [[NSAttributedString alloc] initWithString:@"您还没创建容器哦" attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -self.tableView.frame.size.height/15;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}
@end
