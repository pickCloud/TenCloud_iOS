//
//  TCServerListViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerListViewController.h"
#import "TCClusterRequest.h"
#import "TCServerTableViewCell.h"
#import "TCServerDetailViewController.h"
#import "TCServerSearchRequest.h"
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"
#import "TCServer+CoreDataClass.h"

@interface TCServerListViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UITextField     *keywordField;
@property (nonatomic, strong) NSMutableArray  *serverArray;
- (void) onDeleteServerNotification:(NSNotification*)sender;
- (void) onAddServerButton:(id)sender;
- (IBAction) onRefreshDataButton:(id)sender;
- (IBAction) onFilterButton:(id)sender;
@end

@implementation TCServerListViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务器列表";
    UIImage *addServerImg = [UIImage imageNamed:@"server_nav_add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addServerImg forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddServerButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    _serverArray = [NSMutableArray new];
    
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeleteServerNotification:)
                                                 name:NOTIFICATION_DEL_SERVER
                                               object:nil];
    
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
    
    TCServerSearchRequest *sReq = [[TCServerSearchRequest alloc] initWithServerName:@"翻墙" regionName:@"" providerName:@""];
    [sReq startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        NSLog(@"search resu:%@",serverArray);
    } failure:^(NSString *message) {
        NSLog(@"search fail:%@",message);
    }];
}

- (void) dealloc
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
    
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithServer:server];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void) onDeleteServerNotification:(NSNotification*)sender
{
    TCServer *server = sender.object;
    if (server)
    {
        [_serverArray removeObject:server];
        [_tableView reloadData];
    }
}

- (void) onAddServerButton:(id)sender
{
    NSLog(@"on add server");
}

- (IBAction) onRefreshDataButton:(id)sender
{
    NSLog(@"on refresh data button");
}

- (IBAction) onFilterButton:(id)sender
{
    NSLog(@"on filter button");
}
@end
