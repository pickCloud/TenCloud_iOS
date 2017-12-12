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

#define SERVER_CONTAINER_CELL_REUSE_ID    @"SERVER_CONTAINER_CELL_REUSE_ID"

@interface TCServerContainerTableViewController ()
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
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCServerContainerListRequest *request = [[TCServerContainerListRequest alloc] initWithServerID:_serverID];
    [request startWithSuccess:^(NSArray<NSArray *> *containerArray) {
        NSLog(@"container array:%@",containerArray);
        [weakSelf.containerArray removeAllObjects];
        [weakSelf.containerArray addObjectsFromArray:containerArray];
        [weakSelf.tableView reloadData];
        [weakSelf stopLoading];
    } failure:^(NSString *message) {
        NSLog(@"message:%@",message);
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

@end
