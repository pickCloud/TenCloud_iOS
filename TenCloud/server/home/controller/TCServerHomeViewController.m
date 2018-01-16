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
#import "TCAddServerViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"
#define HEADER_COLLECTION_CELL_REUSE_ID @"HEADER_COLLECTION_CELL_REUSE_ID"

//for test
#import "TCServerLogTableViewController.h"
#import "TCServer+CoreDataClass.h"
#import "TCServerContainerTableViewController.h"
#import "TCServerConfigViewController.h"
#import "TCServerInfoViewController.h"
#import "TCServerMonitorViewController.h"
#import "TCServerListViewController.h"

//test
//#import <MMDrawerController/MMDrawerController.h>
//#import "TCServerFilterViewController.h"

#define SERVER_HOME_HEADER_REUSE_ID     @"SERVER_HOME_HEADER_REUSE_ID"

@interface TCServerHomeViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *serverArray;
@property (nonatomic, weak) IBOutlet    UICollectionView    *headerCollectionView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *headerCollectionBgHeightConstraint;
@property (nonatomic, weak) IBOutlet    UIView              *headerView;
@property (nonatomic, weak) IBOutlet    UIView              *headerCollectionBgView;
- (IBAction) onMoreButton:(id)sender;
- (void) onMessageButton:(id)sender;
- (void) onNotificationChangeCorp;
- (void) reloadServerList;
@end

@implementation TCServerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务器";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    [self wr_setNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
    UIImage *messageIconImg = [UIImage imageNamed:@"nav_message"];
    UIButton *msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgButton setImage:messageIconImg forState:UIControlStateNormal];
    [msgButton sizeToFit];
    [msgButton addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:msgButton];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    _serverArray = [NSMutableArray new];
    //_headerHeightConstraint.constant = TCSCALE(156);
    _tableView.tintColor = [UIColor clearColor];
    _headerView.backgroundColor = THEME_BACKGROUND_COLOR;
    _headerCollectionBgView.backgroundColor = TABLE_CELL_BG_COLOR;
    _headerCollectionBgHeightConstraint.constant = TCSCALE(120);
    //[[UITableViewHeaderFooterView appearance] setTintColor:[UIColor purpleColor]];
    
    
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    
    UINib *homeCollectionNibCell = [UINib nibWithNibName:@"ServerHomeIconCollectionViewCell" bundle:nil];
    [_headerCollectionView registerNib:homeCollectionNibCell forCellWithReuseIdentifier:HEADER_COLLECTION_CELL_REUSE_ID];
    UICollectionViewFlowLayout  *iconLayout = [[UICollectionViewFlowLayout alloc] init];
    //iconLayout.itemSize = CGSizeMake(TCSCALE(117), TCSCALE(100));
    iconLayout.itemSize = CGSizeMake(TCSCALE(116.8), TCSCALE(100));
    iconLayout.minimumInteritemSpacing = TCSCALE(0.0);
    iconLayout.minimumLineSpacing = TCSCALE(0.0);
    float iconX = 0;//_searchCourseButton.frame.origin.x;
    iconLayout.headerReferenceSize = CGSizeMake(iconX, iconX);
    iconLayout.footerReferenceSize = CGSizeMake(iconX, iconX);
    [_headerCollectionView setCollectionViewLayout:iconLayout];
    
    [self startLoading];
    [self reloadServerList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNotificationChangeCorp)
                                                 name:NOTIFICATION_CORP_CHANGE
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithServer:server];
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
    if (indexPath.row == 0)
    {
        [self onMoreButton:nil];
    }else
    {
        [MBProgressHUD showError:@"暂无此页面" toView:nil];
    }
}

- (IBAction) onMoreButton:(id)sender
{
    
    TCServerListViewController *listVC = [TCServerListViewController new];
    [self.navigationController pushViewController:listVC animated:YES];
     /*
    TCServerFilterViewController *filterVC = [TCServerFilterViewController new];
    TCServerListViewController *listVC = [TCServerListViewController new];
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:listVC rightDrawerViewController:filterVC];
    [drawerController setShowsShadow:NO];
    [drawerController setShouldStretchDrawer:NO];
    [drawerController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
    [drawerController setMaximumLeftDrawerWidth:TCSCALE(260)];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    drawerController.title = @"服务器列表";
    drawerController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:drawerController animated:YES];
    */
}

- (void) onMessageButton:(id)sender
{
    [MBProgressHUD showError:@"暂无页面" toView:nil];
}

- (void) onNotificationChangeCorp
{
    [self reloadServerList];
}

- (void) reloadServerList
{
    __weak  __typeof(self)  weakSelf = self;
    TCClusterRequest *request = [[TCClusterRequest alloc] init];
    [request startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        [weakSelf stopLoading];
        [weakSelf.serverArray removeAllObjects];
        [weakSelf.serverArray addObjectsFromArray:serverArray];
        NSLog(@"serverArray%d:%@",serverArray.count, serverArray);
        NSLog(@"server count:%ld",weakSelf.serverArray.count);
        for (int i = weakSelf.serverArray.count; i > 4; i--)
        {
            NSLog(@"删除%d",i);
            [weakSelf.serverArray removeObjectAtIndex:0];
        }
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
        [weakSelf stopLoading];
    }];
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
    return [[NSAttributedString alloc] initWithString:@"暂无服务器,点击添加" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    //[self onAddTemplateButton:nil];
    TCAddServerViewController *addVC = [TCAddServerViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}
@end
