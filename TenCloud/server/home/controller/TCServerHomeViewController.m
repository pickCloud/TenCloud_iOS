//
//  TCServerHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerHomeViewController.h"
#import "TCServerTableViewCell.h"
#import "TCServerDetailViewController.h"
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
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"
#define HEADER_COLLECTION_CELL_REUSE_ID @"HEADER_COLLECTION_CELL_REUSE_ID"



#define SERVER_HOME_HEADER_REUSE_ID     @"SERVER_HOME_HEADER_REUSE_ID"

@interface TCServerHomeViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,
TCMessageManagerDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *serverArray;
@property (nonatomic, assign) NSInteger       totalServerAmount;
@property (nonatomic, strong) UIButton        *messageButton;
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
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithServerID:server.serverID name:server.name];
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
        [cell setTitle:@"服务器总数" icon:@"server_home_server" messageNumber:_totalServerAmount];
    }else if(indexPath.row == 1)
    {
        [cell setTitle:@"安全警告" icon:@"server_home_alarm" messageNumber:0];
    }else
    {
        [cell setTitle:@"缴费信息" icon:@"server_home_money" messageNumber:0];
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
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
    
    //需要与服务器列表一起刷新
    TCServerSummaryRequest *summaryReq = [TCServerSummaryRequest new];
    [summaryReq startWithSuccess:^(TCServerSummary *summary) {
        weakSelf.totalServerAmount = summary.server_num;
        [weakSelf.headerCollectionView reloadData];
    } failure:^(NSString *message) {
        
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

#pragma mark - TCMessageManagerDelegate
- (void) messageCountChanged:(NSInteger)count
{
    _messageButton.badgeView.badgeValue = count;
}
@end
