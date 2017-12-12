//
//  TCServerHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerHomeViewController.h"
#import "TCClusterRequest.h"
#import "TCServerTableViewCell.h"
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"

//for test
#import "TCServerLogTableViewController.h"
#import "TCServer+CoreDataClass.h"
#import "TCServerContainerTableViewController.h"

@interface TCServerHomeViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *serverArray;
@end

@implementation TCServerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务器";
    _serverArray = [NSMutableArray new];
    
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    
    [self startLoading];
    __weak  __typeof(self)  weakSelf = self;
    TCClusterRequest *request = [[TCClusterRequest alloc] init];
    [request startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        [weakSelf.serverArray removeAllObjects];
        [weakSelf.serverArray addObjectsFromArray:serverArray];
        [weakSelf.tableView reloadData];
        [weakSelf stopLoading];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
        [weakSelf stopLoading];
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
    return _serverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CELL_REUSE_ID forIndexPath:indexPath];
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    [cell setServer:server];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerLogTableViewController *logVC = [[TCServerLogTableViewController alloc] initWithID:server.serverID];
    [self.navigationController pushViewController:logVC animated:YES];
     */
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerContainerTableViewController *containerVC = [[TCServerContainerTableViewController alloc] initWithID:server.serverID];
    [self.navigationController pushViewController:containerVC animated:YES];
}

@end
