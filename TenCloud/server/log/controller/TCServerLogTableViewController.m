//
//  TCServerLogTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerLogTableViewController.h"
#import "TCServerLogRequest.h"
#import "TCServerLogTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#define SERVER_LOG_CELL_REUSE_ID    @"SERVER_LOG_CELL_REUSE_ID"

@interface TCServerLogTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, strong)   NSMutableArray  *logArray;
@property (nonatomic, weak)     IBOutlet    UITableView *tableView;
@end

@implementation TCServerLogTableViewController

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
    _logArray = [NSMutableArray new];
    UINib *logCellNib = [UINib nibWithNibName:@"TCServerLogTableViewCell" bundle:nil];
    [_tableView registerNib:logCellNib forCellReuseIdentifier:SERVER_LOG_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCServerLogRequest *request = [[TCServerLogRequest alloc] initWithServerID:_serverID type:0];
    [request startWithSuccess:^(NSArray<TCServerLog *> *logArray) {
        [weakSelf stopLoading];
        [weakSelf.logArray removeAllObjects];
        [weakSelf.logArray addObjectsFromArray:logArray];
        [weakSelf.tableView reloadData];
        NSLog(@"完成加载:%@",weakSelf.logArray);
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
    return _logArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_LOG_CELL_REUSE_ID forIndexPath:indexPath];
    TCServerLog *log = [_logArray objectAtIndex:indexPath.row];
    [cell setLog:log];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    NSLog(@"title for empty ");
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(13.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"暂无日志" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    NSLog(@"should display empty");
    return !self.isLoading;
}
@end
