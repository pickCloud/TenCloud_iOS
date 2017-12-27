//
//  TCMyCorpTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMyCorpTableViewController.h"
#import "TCMyCorpTableViewCell.h"
#import "TCCorpListRequest.h"

#define MY_CORP_CELL_REUSE_ID   @"MY_CORP_CELL_REUSE_ID"

@interface TCMyCorpTableViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *corpArray;
- (void) onAddCorpButton:(id)sender;
- (void) reloadCorpArray;
@end

@implementation TCMyCorpTableViewController

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
    self.title = @"我的企业";
    _corpArray = [NSMutableArray new];
    
    UIImage *addServerImg = [UIImage imageNamed:@"corp_nav_add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addServerImg forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddCorpButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCMyCorpTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:MY_CORP_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    
    [self startLoading];
    [self reloadCorpArray];
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
    return _corpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMyCorpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_CORP_CELL_REUSE_ID forIndexPath:indexPath];
    TCCorp *corp = [_corpArray objectAtIndex:indexPath.row];
    [cell setCorp:corp];
    /*
    TCServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CELL_REUSE_ID forIndexPath:indexPath];
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    [cell setServer:server];
     */
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    /*
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithServer:server];
    [self.navigationController pushViewController:detailVC animated:YES];
     */
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
    return [[NSAttributedString alloc] initWithString:@"您尚未创建或加入企业" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}


#pragma mark - extension
- (void) reloadCorpArray
{
    __weak __typeof(self) weakSelf = self;
    TCCorpListRequest   *request = [[TCCorpListRequest alloc] init];
    [request startWithSuccess:^(NSArray<TCCorp *> *corpArray) {
        NSLog(@"corp list:%@",corpArray);
        [weakSelf.corpArray removeAllObjects];
        [weakSelf.corpArray addObjectsFromArray:corpArray];
        [weakSelf.tableView reloadData];
        [weakSelf stopLoading];
    } failure:^(NSString *message) {
        NSLog(@"my corp req failed:%@",message);
    }];
}

- (void) onAddCorpButton:(id)sender
{
    
}
@end
