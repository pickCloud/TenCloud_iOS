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
#import "TCServerDetailViewController.h"
#import "ServerHomeIconCollectionViewCell.h"
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"
#define HEADER_COLLECTION_CELL_REUSE_ID @"HEADER_COLLECTION_CELL_REUSE_ID"

//for test
#import "TCServerLogTableViewController.h"
#import "TCServer+CoreDataClass.h"
#import "TCServerContainerTableViewController.h"
#import "TCServerConfigViewController.h"
#import "TCServerInfoViewController.h"
#import "TCServerMonitorViewController.h"

#define SERVER_HOME_HEADER_REUSE_ID     @"SERVER_HOME_HEADER_REUSE_ID"

@interface TCServerHomeViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *serverArray;
@property (nonatomic, weak) IBOutlet    UICollectionView    *headerCollectionView;
- (IBAction) onMoreButton:(id)sender;
@end

@implementation TCServerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务器";
    _serverArray = [NSMutableArray new];
    
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    
    UINib *homeCollectionNibCell = [UINib nibWithNibName:@"ServerHomeIconCollectionViewCell" bundle:nil];
    [_headerCollectionView registerNib:homeCollectionNibCell forCellWithReuseIdentifier:HEADER_COLLECTION_CELL_REUSE_ID];
    UICollectionViewFlowLayout  *iconLayout = [[UICollectionViewFlowLayout alloc] init];
    iconLayout.itemSize = CGSizeMake(TCSCALE(117), TCSCALE(100));
    iconLayout.minimumInteritemSpacing = TCSCALE(0.0);
    iconLayout.minimumLineSpacing = TCSCALE(0.0);
    float iconX = 0;//_searchCourseButton.frame.origin.x;
    iconLayout.headerReferenceSize = CGSizeMake(iconX, iconX);
    iconLayout.footerReferenceSize = CGSizeMake(iconX, iconX);
    [_headerCollectionView setCollectionViewLayout:iconLayout];
    
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
    
    /*
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerContainerTableViewController *containerVC = [[TCServerContainerTableViewController alloc] initWithID:server.serverID];
    [self.navigationController pushViewController:containerVC animated:YES];
     */
    
    /*
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerConfigViewController *configVC = [[TCServerConfigViewController alloc] initWithID:server.serverID];
    [self.navigationController pushViewController:configVC animated:YES];
     */
    
    /*
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerInfoViewController *infoVC = [[TCServerInfoViewController alloc] initWithID:server.serverID];
    [self.navigationController pushViewController:infoVC animated:YES];
     */
    
    /*
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerMonitorViewController *monitorVC = [[TCServerMonitorViewController alloc] initWithID:server.serverID];
    [self.navigationController pushViewController:monitorVC animated:YES];
     */
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithID:server.serverID name:server.name];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ServerHomeIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HEADER_COLLECTION_CELL_REUSE_ID forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        [cell setTitle:@"服务器总数" icon:@"server_home_server" messageNumber:5];
    }else if(indexPath.row == 1)
    {
        [cell setTitle:@"安全警告" icon:@"server_home_alarm" messageNumber:10];
    }else
    {
        [cell setTitle:@"缴费信息" icon:@"server_home_money" messageNumber:9];
    }
    return cell;
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item:%d %d",(int)indexPath.section, (int)indexPath.row);
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (IBAction) onMoreButton:(id)sender
{
    
}
@end
