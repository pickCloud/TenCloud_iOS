//
//  TCMonitorHistoryTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/29.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCMonitorHistoryTableViewController.h"
#import "TCPerformanceHistoryRequest.h"
#import "TCServer+CoreDataClass.h"
#import "TCMonitorHistoryTableViewCell.h"
#import "TCPerformanceItem+CoreDataClass.h"
#import "MKDropdownMenu.h"
#import "ShapeSelectView.h"
#import "TCHistoryTimeFilterViewController.h"
#import "TCMonitorHistoryTime.h"
#import "TCTextRefreshAutoFooter.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


#define MONITOR_HISTORY_PER_PAGE    20
#define MONITOR_HISTORY_CELL_ID     @"MONITOR_HISTORY_CELL_ID"

@interface TCMonitorHistoryTableViewController ()<MKDropdownMenuDelegate,MKDropdownMenuDataSource,
DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    MKDropdownMenu  *typeMenu;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, assign)   NSInteger               serverID;
@property (nonatomic, strong)   NSMutableArray          *performanceArray;
@property (nonatomic, strong)   NSMutableArray          *typeMenuOptions;
@property (nonatomic, assign)   NSInteger               selectedMenuIndex;
@property (nonatomic, assign)   NSInteger               pageIndex;
- (void) reloadHistory;
- (void) loadMoreHistory;
- (IBAction) onTimeFilterButton:(id)sender;
@end

@implementation TCMonitorHistoryTableViewController

- (instancetype) initWithServerID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
        _pageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    _performanceArray = [NSMutableArray new];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    [[TCMonitorHistoryTime shared] reset];
    [self startLoading];
    [self reloadHistory];

    UINib *cellNib = [UINib nibWithNibName:@"TCMonitorHistoryTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:MONITOR_HISTORY_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    _typeMenuOptions = [NSMutableArray new];
    [_typeMenuOptions addObject:@"正常"];
    [_typeMenuOptions addObject:@"按时平均"];
    [_typeMenuOptions addObject:@"按天平均"];
    
    UIColor *dropDownBgColor = [UIColor colorWithRed:39/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    self.typeMenu.selectedComponentBackgroundColor = dropDownBgColor;
    self.typeMenu.dropdownBackgroundColor = dropDownBgColor;
    self.typeMenu.dropdownShowsTopRowSeparator = YES;
    self.typeMenu.dropdownShowsBottomRowSeparator = NO;
    self.typeMenu.dropdownShowsBorder = NO;
    self.typeMenu.backgroundDimmingOpacity = 0.5;//0.05;
    self.typeMenu.componentTextAlignment = NSTextAlignmentLeft;
    self.typeMenu.dropdownCornerRadius = TCSCALE(4.0);
    self.typeMenu.rowSeparatorColor = THEME_BACKGROUND_COLOR;
    
    UIImage *disclosureImg = [UIImage imageNamed:@"dropdown"];
    self.typeMenu.disclosureIndicatorImage = disclosureImg;
    
    TCTextRefreshAutoFooter *footer = [TCTextRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHistory)];
    footer.automaticallyRefresh = YES;
    footer.automaticallyHidden = YES;
    self.tableView.mj_footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_typeMenu closeAllComponentsAnimated:YES];
}

#pragma mark - extension
- (void) reloadHistory
{
    _pageIndex = 1;//0;
    __weak __typeof(self) weakSelf = self;
    TCPerformanceHistoryRequest *req = nil;
    NSInteger type = _selectedMenuIndex + 1;
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    //startTime = endTime - 86400;      //24hour
    //startTime = endTime - 604800;     //one week
    startTime = endTime - 18144000;     //one month
    TCMonitorHistoryTime *historyTime = [TCMonitorHistoryTime shared];
    if (historyTime.startTime > 0)
    {
        startTime = historyTime.startTime;
    }
    if (historyTime.endTime > 0)
    {
        endTime = historyTime.endTime;
    }
    [weakSelf startLoading];
    req = [[TCPerformanceHistoryRequest alloc] initWithServerID:_serverID
                                                           type:type
                                                      startTime:startTime
                                                        endTime:endTime
                                                           page:_pageIndex
                                                  amountPerPage:MONITOR_HISTORY_PER_PAGE];
    [req startWithSuccess:^(NSArray<TCPerformanceItem *> *perfArray) {
        [weakSelf stopLoading];
        [weakSelf.performanceArray removeAllObjects];
        [weakSelf.performanceArray addObjectsFromArray:perfArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
}

- (void) loadMoreHistory
{
    __weak __typeof(self) weakSelf = self;
    TCPerformanceHistoryRequest *req = nil;
    NSInteger type = _selectedMenuIndex + 1;
    NSInteger endTime = [[NSDate date] timeIntervalSince1970];
    NSInteger startTime = endTime - 3600;
    //startTime = endTime - 86400;      //24hour
    //startTime = endTime - 604800;     //one week
    startTime = endTime - 18144000;     //one month
    TCMonitorHistoryTime *historyTime = [TCMonitorHistoryTime shared];
    if (historyTime.startTime > 0)
    {
        startTime = historyTime.startTime;
    }
    if (historyTime.endTime > 0)
    {
        endTime = historyTime.endTime;
    }
    req = [[TCPerformanceHistoryRequest alloc] initWithServerID:_serverID
                                                           type:type
                                                      startTime:startTime
                                                        endTime:endTime
                                                           page:_pageIndex + 1
                                                  amountPerPage:MONITOR_HISTORY_PER_PAGE];
    [req startWithSuccess:^(NSArray<TCPerformanceItem *> *perfArray) {
        [weakSelf.tableView.mj_footer endRefreshing];
        if (perfArray.count)
        {
            [self.performanceArray addObjectsFromArray:perfArray];
            self.pageIndex ++;
        }else
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf stopLoading];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (IBAction) onTimeFilterButton:(id)sender
{
    [_typeMenu closeAllComponentsAnimated:YES];
    __weak __typeof(self) weakSelf = self;
    TCHistoryTimeFilterViewController *filterVC = [TCHistoryTimeFilterViewController new];
    filterVC.valueChangedBlock = ^(TCHistoryTimeFilterViewController *cell) {
        [weakSelf reloadHistory];
    };
    filterVC.providesPresentationContextTransitionStyle = YES;
    filterVC.definesPresentationContext = YES;
    filterVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:filterVC animated:NO completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _performanceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCPerformanceItem *item = [_performanceArray objectAtIndex:indexPath.row];
    TCMonitorHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MONITOR_HISTORY_CELL_ID forIndexPath:indexPath];
    [cell setPerformance:item];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    return [[NSAttributedString alloc] initWithString:@"暂无历史记录" attributes:attributes];
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


#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return _typeMenuOptions.count;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return TCSCALE(32);
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return MAX(dropdownMenu.bounds.size.width/3, 125);
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    UIFont *menuFont = [UIFont systemFontOfSize:TCSCALE(12)];
    NSDictionary *attr = @{NSFontAttributeName:menuFont,
                           NSForegroundColorAttributeName: THEME_PLACEHOLDER_COLOR};
    NSString *str = self.typeMenuOptions[_selectedMenuIndex];
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:attr];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component {
    UIFont *menuFont = [UIFont systemFontOfSize:TCSCALE(12)];
    NSDictionary *attr = @{NSFontAttributeName:menuFont,
                           NSForegroundColorAttributeName: THEME_TEXT_COLOR};
    NSString *str = self.typeMenuOptions[_selectedMenuIndex];
    return [[NSAttributedString alloc] initWithString:str
                                           attributes:attr];
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ShapeSelectView *shapeSelectView = (ShapeSelectView *)view;
    if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[ShapeSelectView class]]) {
        shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShapeSelectView class]) owner:nil options:nil] firstObject];
    }
    NSString *statusStr = self.typeMenuOptions[row];
    shapeSelectView.textLabel.text = statusStr;
    shapeSelectView.selected = _selectedMenuIndex == row;
    return shapeSelectView;
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self colorForRow:row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedMenuIndex = row;
    [dropdownMenu reloadComponent:component];
    [dropdownMenu closeAllComponentsAnimated:YES];
    [self reloadHistory];
}

- (UIColor *)colorForRow:(NSInteger)row {
    return DROPDOWN_CELL_BG_COLOR;
}
@end
