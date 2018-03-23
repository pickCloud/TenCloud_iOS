//
//  TCServerHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerHomeViewController.h"
#import "TCServerTableViewCell.h"
//#import "TCServerDetailViewController.h"
#import "ServerHomeIconCollectionViewCell.h"
#import "TCAddServerViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TCServerWarningRequest.h"
#import "TCServerSummaryRequest.h"
#import "TCServerSummary+CoreDataClass.h"
#import "TCMessageManager.h"
#import "UIView+MGBadgeView.h"
#import "TCMessageTableViewController.h"
#import "TCServer+CoreDataClass.h"
#import "TCServerListViewController.h"
#import "TCDataSync.h"
#import "TCTextRefreshHeader.h"
#import "TCServerProfileViewController.h"
#import "TCServerUsage+CoreDataClass.h"
#import "TCServerHomeUsageCell.h"
#import "TCServerUsageRequest.h"
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"
#define HEADER_COLLECTION_CELL_REUSE_ID @"HEADER_COLLECTION_CELL_REUSE_ID"
#define SERVER_HOME_HEADER_REUSE_ID     @"SERVER_HOME_HEADER_REUSE_ID"
#define SERVER_HOME_USAGE_REUSE_ID      @"SERVER_HOME_USAGE_REUSE_ID"


@interface TCServerHomeViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,
TCMessageManagerDelegate,TCDataSyncDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *serverArray;
@property (nonatomic, assign) NSInteger       totalServerAmount;
@property (nonatomic, strong) UIButton        *messageButton;
@property (nonatomic, strong) NSMutableArray  *usageArray;
@property (nonatomic, strong) NSTimer         *usageDataTimer;
@property (nonatomic, weak) IBOutlet    UICollectionView    *headerCollectionView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *headerCollectionBgHeightConstraint;
@property (nonatomic, weak) IBOutlet    UIView              *headerView;
@property (nonatomic, weak) IBOutlet    UIView              *headerCollectionBgView;
- (IBAction) onMoreButton:(id)sender;
- (void) onMessageButton:(id)sender;
- (void) onNotificationChangeCorp;
- (void) reloadServerList;
- (void) reloadUsageData;

//for fake usage data
@property (nonatomic, assign)   TCServerUsageType   alertType;
@property (nonatomic, assign)   int                 columnAmount;
//- (void) oneServerChangeAlertType;
//- (void) usageDataWith4Server;
//- (void) usageDataWith7Server;
//- (void) usageDataWith10Server;
//- (void) switchColumnAmount;
@end

@implementation TCServerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"主机/集群";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    [self wr_setNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
    UIImage *messageIconImg = [UIImage imageNamed:@"nav_message"];
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_messageButton setImage:messageIconImg forState:UIControlStateNormal];
    [_messageButton sizeToFit];
    [_messageButton addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger msgCount = [[TCMessageManager shared] count];
    [_messageButton.badgeView setBadgeValue:msgCount];
    [_messageButton.badgeView setOutlineWidth:0.0];
    [_messageButton.badgeView setBadgeColor:[UIColor redColor]];
    [_messageButton.badgeView setMinDiameter:18.0];
    [_messageButton.badgeView setPosition:MGBadgePositionTopRight];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:_messageButton];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    _serverArray = [NSMutableArray new];
    _tableView.tintColor = [UIColor clearColor];
    _headerView.backgroundColor = THEME_BACKGROUND_COLOR;
    _headerCollectionBgView.backgroundColor = TABLE_CELL_BG_COLOR;
    _headerCollectionBgHeightConstraint.constant = TCSCALE(120);
    
    
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    UINib *usageCellNib = [UINib nibWithNibName:@"TCServerHomeUsageCell" bundle:nil];
    [_tableView registerNib:usageCellNib forCellReuseIdentifier:SERVER_HOME_USAGE_REUSE_ID];
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.estimatedRowHeight = 200;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    UINib *homeCollectionNibCell = [UINib nibWithNibName:@"ServerHomeIconCollectionViewCell" bundle:nil];
    [_headerCollectionView registerNib:homeCollectionNibCell forCellWithReuseIdentifier:HEADER_COLLECTION_CELL_REUSE_ID];
    UICollectionViewFlowLayout  *iconLayout = [[UICollectionViewFlowLayout alloc] init];
    iconLayout.itemSize = CGSizeMake(TCSCALE(116.8), TCSCALE(100));
    iconLayout.minimumInteritemSpacing = TCSCALE(0.0);
    iconLayout.minimumLineSpacing = TCSCALE(0.0);
    float iconX = 0;
    iconLayout.headerReferenceSize = CGSizeMake(iconX, iconX);
    iconLayout.footerReferenceSize = CGSizeMake(iconX, iconX);
    [_headerCollectionView setCollectionViewLayout:iconLayout];
    
    if (self.tableView.mj_header == nil)
    {
        TCTextRefreshHeader *refreshHeader = [TCTextRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadServerList)];
        refreshHeader.automaticallyChangeAlpha = YES;
        self.tableView.mj_header = refreshHeader;
    }
    
    [self startLoading];
    [self reloadServerList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadServerList)
                                                 name:NOTIFICATION_CORP_CHANGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadServerList)
                                                 name:NOTIFICATION_MODIFY_SERVER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadServerList)
                                                 name:NOTIFICATION_ADD_SERVER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadServerList)
                                                 name:NOTIFICATION_DEL_SERVER
                                               object:nil];
    [[TCMessageManager shared] addObserver:self];
    [[TCDataSync shared] addPermissionChangedObserver:self];
    
    _usageArray = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _usageDataTimer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                       target:self
                                                     selector:@selector(reloadUsageData)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_usageDataTimer)
    {
        [_usageDataTimer invalidate];
        _usageDataTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[TCDataSync shared] removePermissionChangedObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_serverArray.count > 0)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
    {
        return 1;
    }
    return _serverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
    {
        TCServerHomeUsageCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_HOME_USAGE_REUSE_ID forIndexPath:indexPath];
        [cell setNavController:self.navigationController];
        [cell setUsageData:_usageArray];
        return cell;
    }
    TCServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CELL_REUSE_ID forIndexPath:indexPath];
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    [cell setServer:server];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        return;
    }
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    
    /*
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithServerID:server.serverID name:server.name];
    [self.navigationController pushViewController:detailVC animated:YES];
     */
    TCServerProfileViewController *profileVC = [[TCServerProfileViewController alloc] initWithID:server.serverID];
    [self.navigationController pushViewController:profileVC animated:YES];
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
        [cell setTitle:@"主机总数" icon:@"server_home_server" messageNumber:_totalServerAmount];
    }else if(indexPath.row == 1)
    {
        [cell setTitle:@"集群总数" icon:@"server_home_cluster" messageNumber:0];
    }else
    {
        [cell setTitle:@"安全警告" icon:@"server_home_alarm" messageNumber:0];
    }
    return cell;
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        [self onMoreButton:nil];
    }else if(indexPath.row == 1)
    {
        //[self oneServerChangeAlertType];
        [MBProgressHUD showError:@"暂无此页面" toView:nil];
    }else
    {
        //[self usageDataWith4Server];
        //[self switchColumnAmount];
        [MBProgressHUD showError:@"暂无此页面" toView:nil];
    }
}

- (IBAction) onMoreButton:(id)sender
{
    
    TCServerListViewController *listVC = [TCServerListViewController new];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void) onMessageButton:(id)sender
{
    TCMessageTableViewController *msgVC = [TCMessageTableViewController new];
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (void) onNotificationChangeCorp
{
    [self reloadServerList];
}

- (void) reloadServerList
{
    __weak  __typeof(self)  weakSelf = self;
    TCServerWarningRequest *req = [[TCServerWarningRequest alloc] init];
    [req startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        [weakSelf stopLoading];
        [weakSelf.serverArray removeAllObjects];
        [weakSelf.serverArray addObjectsFromArray:serverArray];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
    
    //需要与服务器列表一起刷新
    TCServerSummaryRequest *summaryReq = [TCServerSummaryRequest new];
    [summaryReq startWithSuccess:^(TCServerSummary *summary) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.totalServerAmount = summary.server_num;
        [weakSelf.headerCollectionView reloadData];
    } failure:^(NSString *message) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self reloadUsageData];
}

- (void) reloadUsageData
{
    __weak __typeof(self) weakSelf = self;
    TCServerUsageRequest *req = [TCServerUsageRequest new];
    [req startWithSuccess:^(NSArray<TCServerUsage *> *usageArray) {
        NSLog(@"获取%ld usage",usageArray.count);
        [weakSelf.usageArray removeAllObjects];
        [weakSelf.usageArray addObjectsFromArray:usageArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        NSLog(@"获取usage fail");
    }];
}

#pragma mark - DZNEmptyDataSetSource Methods

 - (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
 {
     return [UIImage imageNamed:@"server_no_data"];
 }

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(12.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR2 forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"对不起，你还没有任何服务器" attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    BOOL canAdd = currentCorp.isAdmin ||
    [currentCorp havePermissionForFunc:FUNC_ID_ADD_SERVER] ||
    currentCorp.cid == 0;
    if (canAdd)
    {
        NSString *text = @"马上去添加";
        UIFont *textFont = TCFont(14.0);
        NSMutableDictionary *attributes = [NSMutableDictionary new];
        [attributes setObject:textFont forKey:NSFontAttributeName];
        if (state == UIControlStateNormal)
        {
            [attributes setObject:THEME_TINT_COLOR forKey:NSForegroundColorAttributeName];
        }else
        {
            [attributes setObject:THEME_TINT_P_COLOR forKey:NSForegroundColorAttributeName];
        }
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    return nil;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    BOOL canAdd = currentCorp.isAdmin ||
    [currentCorp havePermissionForFunc:FUNC_ID_ADD_SERVER] ||
    currentCorp.cid == 0;
    if (canAdd)
    {
        UIEdgeInsets capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
        UIEdgeInsets rectInsets = UIEdgeInsetsMake(0.0, TCSCALE(-112), 0.0, TCSCALE(-112));
        UIImage *image = nil;
        if (state == UIControlStateNormal)
        {
            image = [UIImage imageNamed:@"no_data_button_bg"];
        }else
        {
            image = [UIImage imageNamed:@"no_data_button_bg_p"];
        }
        return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
    }
    return nil;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return TCSCALE(50);
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    TCAddServerViewController *addVC = [TCAddServerViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - TCMessageManagerDelegate
- (void) messageCountChanged:(NSInteger)count
{
    _messageButton.badgeView.badgeValue = count;
}

#pragma mark - TCDataSyncDelegate
- (void) dataSync:(TCDataSync*)sync permissionChanged:(NSInteger)changed
{
    [self.tableView reloadData];
}

#pragma mark - for fake usage data
/*
- (void) oneServerChangeAlertType
{
    [_usageArray removeAllObjects];
    if (_alertType < TCServerUsageCrit)
    {
        _alertType = _alertType + 1;
    }else
    {
        _alertType = TCServerUsageIdle;
    }
    
    int fakeServerID = 186;
#if ONLINE_ENVIROMENT
    fakeServerID = 20;
#endif
    if (_alertType == TCServerUsageIdle)
    {
        TCServerUsage *usage1 = [TCServerUsage MR_createEntity];
        usage1.serverID = fakeServerID;
        usage1.name = @"@Ten_备用翻墙";
        usage1.cpuUsageRate = @(0.12);
        usage1.diskUsageRate = 0.29;
        usage1.memUsageRate = 0.3;
        usage1.networkUsage = @"22/33";
        usage1.diskIO = @"33/44";
        usage1.colorType = TCServerUsageIdle;
        [_usageArray addObject:usage1];
    }else if(_alertType == TCServerUsageSafe)
    {
        TCServerUsage *usage2 = [TCServerUsage MR_createEntity];
        usage2.serverID = fakeServerID;
        usage2.name = @"@Ye教育_线上环境";
        usage2.cpuUsageRate = 0.22;
        usage2.diskUsageRate = 0.39;
        usage2.memUsageRate = 0.43;
        usage2.networkUsage = @"55/66";
        usage2.diskIO = @"77/88";
        usage2.colorType = TCServerUsageSafe;
        [_usageArray addObject:usage2];
    }else if(_alertType == TCServerUsageWarning)
    {
        TCServerUsage *usage3 = [TCServerUsage MR_createEntity];
        usage3.serverID = fakeServerID;
        usage3.name = @"@Aimer+WF";
        usage3.cpuUsageRate = 0.27;
        usage3.diskUsageRate = 0.31;
        usage3.memUsageRate = 0.26;
        usage3.networkUsage = @"55/66";
        usage3.diskIO = @"77/88";
        usage3.colorType = TCServerUsageWarning;
        [_usageArray addObject:usage3];
    }else if(_alertType == TCServerUsageAlert)
    {
        TCServerUsage *usage4 = [TCServerUsage MR_createEntity];
        usage4.serverID = fakeServerID;
        usage4.name = @"@TenCloud官网";
        usage4.cpuUsageRate = 0.22;
        usage4.diskUsageRate = 0.37;
        usage4.memUsageRate = 0.13;
        usage4.networkUsage = @"55/66";
        usage4.diskIO = @"77/88";
        usage4.colorType = TCServerUsageAlert;
        [_usageArray addObject:usage4];
    }else
    {
        TCServerUsage *usage5 = [TCServerUsage MR_createEntity];
        usage5.serverID = fakeServerID;
        usage5.name = @"@TenCloud_开发环境";
        usage5.cpuUsageRate = 0.12;
        usage5.diskUsageRate = 0.19;
        usage5.memUsageRate = 0.34;
        usage5.networkUsage = @"55/66";
        usage5.diskIO = @"77/88";
        usage5.colorType = TCServerUsageCrit;
        [_usageArray addObject:usage5];
    }
    [self.tableView reloadData];
}

- (void) usageDataWith4Server
{
    [_usageArray removeAllObjects];
    
    int fakeServerID = 186;
#if ONLINE_ENVIROMENT
    fakeServerID = 20;
#endif
    TCServerUsage *usage1 = [TCServerUsage MR_createEntity];
    usage1.serverID = fakeServerID;
    usage1.name = @"@TenCloud_测试环境";
    usage1.cpuUsageRate = 0.92;
    usage1.diskUsageRate = 0.39;
    usage1.memUsageRate = 0.93;
    usage1.networkUsage = @"22/33";
    usage1.diskIO = @"33/44";
    usage1.colorType = TCServerUsageCrit;
    [_usageArray addObject:usage1];
    
    TCServerUsage *usage2 = [TCServerUsage MR_createEntity];
    usage2.serverID = fakeServerID;
    usage2.name = @"@TenCloud_Docker仓库";
    usage2.cpuUsageRate = 0.82;
    usage2.diskUsageRate = 0.39;
    usage2.memUsageRate = 0.43;
    usage2.networkUsage = @"55/66";
    usage2.diskIO = @"77/88";
    usage2.colorType = TCServerUsageAlert;
    [_usageArray addObject:usage2];
    
    TCServerUsage *usage3 = [TCServerUsage MR_createEntity];
    usage3.serverID = fakeServerID;
    usage3.name = @"@Aimer_WF+";
    usage3.cpuUsageRate = 0.27;
    usage3.diskUsageRate = 0.31;
    usage3.memUsageRate = 0.26;
    usage3.networkUsage = @"55/66";
    usage3.diskIO = @"77/88";
    usage3.colorType = TCServerUsageSafe;
    [_usageArray addObject:usage3];
    
    TCServerUsage *usage4 = [TCServerUsage MR_createEntity];
    usage4.serverID = fakeServerID;
    usage4.name = @"@Aimer_Infohub";
    usage4.cpuUsageRate = 0.22;
    usage4.diskUsageRate = 0.17;
    usage4.memUsageRate = 0.13;
    usage4.networkUsage = @"55/66";
    usage4.diskIO = @"77/88";
    usage4.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage4];
    [self.tableView reloadData];
}

- (void) usageDataWith7Server
{
    [_usageArray removeAllObjects];
    
    int fakeServerID = 186;
#if ONLINE_ENVIROMENT
    fakeServerID = 20;
#endif
    TCServerUsage *usage1 = [TCServerUsage MR_createEntity];
    usage1.serverID = fakeServerID;
    usage1.name = @"@TenCloud_测试环境";
    usage1.cpuUsageRate = 0.92;
    usage1.diskUsageRate = 0.39;
    usage1.memUsageRate = 0.93;
    usage1.networkUsage = @"22/33";
    usage1.diskIO = @"33/44";
    usage1.colorType = TCServerUsageCrit;
    [_usageArray addObject:usage1];
    
    TCServerUsage *usage2 = [TCServerUsage MR_createEntity];
    usage2.serverID = fakeServerID;
    usage2.name = @"@TenCloud_Docker仓库";
    usage2.cpuUsageRate = 0.82;
    usage2.diskUsageRate = 0.39;
    usage2.memUsageRate = 0.43;
    usage2.networkUsage = @"55/66";
    usage2.diskIO = @"77/88";
    usage2.colorType = TCServerUsageAlert;
    [_usageArray addObject:usage2];
    
    TCServerUsage *usage3 = [TCServerUsage MR_createEntity];
    usage3.serverID = fakeServerID;
    usage3.name = @"@Aimer_WF+";
    usage3.cpuUsageRate = 0.27;
    usage3.diskUsageRate = 0.31;
    usage3.memUsageRate = 0.26;
    usage3.networkUsage = @"55/66";
    usage3.diskIO = @"77/88";
    usage3.colorType = TCServerUsageWarning;
    [_usageArray addObject:usage3];
    
    TCServerUsage *usage4 = [TCServerUsage MR_createEntity];
    usage4.serverID = fakeServerID;
    usage4.name = @"@Aimer_Infohub";
    usage4.cpuUsageRate = 0.22;
    usage4.diskUsageRate = 0.17;
    usage4.memUsageRate = 0.13;
    usage4.networkUsage = @"55/66";
    usage4.diskIO = @"77/88";
    usage4.colorType = TCServerUsageSafe;
    [_usageArray addObject:usage4];
    
    TCServerUsage *usage5 = [TCServerUsage MR_createEntity];
    usage5.serverID = fakeServerID;
    usage5.name = @"@Ten_备用翻墙";
    usage5.cpuUsageRate = 0.22;
    usage5.diskUsageRate = 0.17;
    usage5.memUsageRate = 0.13;
    usage5.networkUsage = @"55/66";
    usage5.diskIO = @"77/88";
    usage5.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage5];
    
    TCServerUsage *usage6 = [TCServerUsage MR_createEntity];
    usage6.serverID = fakeServerID;
    usage6.name = @"@Ye教育_线上环境";
    usage6.cpuUsageRate = 0.22;
    usage6.diskUsageRate = 0.17;
    usage6.memUsageRate = 0.13;
    usage6.networkUsage = @"55/66";
    usage6.diskIO = @"77/88";
    usage6.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage6];
    
    TCServerUsage *usage7 = [TCServerUsage MR_createEntity];
    usage7.serverID = fakeServerID;
    usage7.name = @"@Ye教育_开发测试";
    usage7.cpuUsageRate = 0.22;
    usage7.diskUsageRate = 0.17;
    usage7.memUsageRate = 0.13;
    usage7.networkUsage = @"55/66";
    usage7.diskIO = @"77/88";
    usage7.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage7];
    
    TCServerUsage *usage8 = [TCServerUsage MR_createEntity];
    usage8.serverID = fakeServerID;
    usage8.name = @"@Ten_备用翻墙";
    usage8.cpuUsageRate = 0.22;
    usage8.diskUsageRate = 0.17;
    usage8.memUsageRate = 0.13;
    usage8.networkUsage = @"55/66";
    usage8.diskIO = @"77/88";
    usage8.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage8];
    
    TCServerUsage *usage9 = [TCServerUsage MR_createEntity];
    usage9.serverID = fakeServerID;
    usage9.name = @"@Ten_官网";
    usage9.cpuUsageRate = 0.22;
    usage9.diskUsageRate = 0.17;
    usage9.memUsageRate = 0.13;
    usage9.networkUsage = @"55/66";
    usage9.diskIO = @"77/88";
    usage9.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage9];
    
    [self.tableView reloadData];
}

- (void) usageDataWith10Server
{
    [_usageArray removeAllObjects];
    
    int fakeServerID = 186;
#if ONLINE_ENVIROMENT
    fakeServerID = 20;
#endif
    TCServerUsage *usage1 = [TCServerUsage MR_createEntity];
    usage1.serverID = fakeServerID;
    usage1.name = @"@TenCloud_测试环境";
    usage1.cpuUsageRate = 0.92;
    usage1.diskUsageRate = 0.39;
    usage1.memUsageRate = 0.93;
    usage1.networkUsage = @"22/33";
    usage1.diskIO = @"33/44";
    usage1.colorType = TCServerUsageCrit;
    [_usageArray addObject:usage1];
    
    TCServerUsage *usage2 = [TCServerUsage MR_createEntity];
    usage2.serverID = fakeServerID;
    usage2.name = @"@TenCloud_Docker仓库";
    usage2.cpuUsageRate = 0.82;
    usage2.diskUsageRate = 0.39;
    usage2.memUsageRate = 0.43;
    usage2.networkUsage = @"55/66";
    usage2.diskIO = @"77/88";
    usage2.colorType = TCServerUsageAlert;
    [_usageArray addObject:usage2];
    
    TCServerUsage *usage3 = [TCServerUsage MR_createEntity];
    usage3.serverID = fakeServerID;
    usage3.name = @"@Aimer_WF+";
    usage3.cpuUsageRate = 0.27;
    usage3.diskUsageRate = 0.31;
    usage3.memUsageRate = 0.26;
    usage3.networkUsage = @"55/66";
    usage3.diskIO = @"77/88";
    usage3.colorType = TCServerUsageWarning;
    [_usageArray addObject:usage3];
    
    TCServerUsage *usage4 = [TCServerUsage MR_createEntity];
    usage4.serverID = fakeServerID;
    usage4.name = @"@Aimer_Infohub";
    usage4.cpuUsageRate = 0.22;
    usage4.diskUsageRate = 0.17;
    usage4.memUsageRate = 0.13;
    usage4.networkUsage = @"55/66";
    usage4.diskIO = @"77/88";
    usage4.colorType = TCServerUsageSafe;
    [_usageArray addObject:usage4];
    
    TCServerUsage *usage5 = [TCServerUsage MR_createEntity];
    usage5.serverID = fakeServerID;
    usage5.name = @"@Ten_备用翻墙";
    usage5.cpuUsageRate = 0.22;
    usage5.diskUsageRate = 0.17;
    usage5.memUsageRate = 0.13;
    usage5.networkUsage = @"55/66";
    usage5.diskIO = @"77/88";
    usage5.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage4];
    
    TCServerUsage *usage6 = [TCServerUsage MR_createEntity];
    usage6.serverID = fakeServerID;
    usage6.name = @"@Ten_中间件";
    usage6.cpuUsageRate = 0.22;
    usage6.diskUsageRate = 0.17;
    usage6.memUsageRate = 0.13;
    usage6.networkUsage = @"55/66";
    usage6.diskIO = @"77/88";
    usage6.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage6];
    
    TCServerUsage *usage7 = [TCServerUsage MR_createEntity];
    usage7.serverID = fakeServerID;
    usage7.name = @"@Ye教育_线上环境";
    usage7.cpuUsageRate = 0.22;
    usage7.diskUsageRate = 0.17;
    usage7.memUsageRate = 0.13;
    usage7.networkUsage = @"55/66";
    usage7.diskIO = @"77/88";
    usage7.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage7];
    
    TCServerUsage *usage8 = [TCServerUsage MR_createEntity];
    usage8.serverID = fakeServerID;
    usage8.name = @"@Ye教育_开发测试";
    usage8.cpuUsageRate = 0.22;
    usage8.diskUsageRate = 0.17;
    usage8.memUsageRate = 0.13;
    usage8.networkUsage = @"55/66";
    usage8.diskIO = @"77/88";
    usage8.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage8];
    
    TCServerUsage *usage9 = [TCServerUsage MR_createEntity];
    usage9.serverID = fakeServerID;
    usage9.name = @"@Ten_官网";
    usage9.cpuUsageRate = 0.22;
    usage9.diskUsageRate = 0.17;
    usage9.memUsageRate = 0.13;
    usage9.networkUsage = @"55/66";
    usage9.diskIO = @"77/88";
    usage9.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage9];
    
    TCServerUsage *usage10 = [TCServerUsage MR_createEntity];
    usage10.serverID = fakeServerID;
    usage10.name = @"@测试机";
    usage10.cpuUsageRate = 0.22;
    usage10.diskUsageRate = 0.17;
    usage10.memUsageRate = 0.13;
    usage10.networkUsage = @"55/66";
    usage10.diskIO = @"77/88";
    usage10.colorType = TCServerUsageIdle;
    [_usageArray addObject:usage10];
    
    [self.tableView reloadData];
}

- (void) switchColumnAmount
{
    if (_columnAmount == 3)
    {
        _columnAmount = 0;
    }
    _columnAmount ++;
    if (_columnAmount == 1)
    {
        [self usageDataWith4Server];
    }else if(_columnAmount == 2)
    {
        [self usageDataWith7Server];
    }else
    {
        [self usageDataWith10Server];
    }
    
}
 */
@end
