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

#define MONITOR_HISTORY_CELL_ID     @"MONITOR_HISTORY_CELL_ID"

@interface TCMonitorHistoryTableViewController ()<MKDropdownMenuDelegate,MKDropdownMenuDataSource>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    MKDropdownMenu  *typeMenu;
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
    
    //__weak __typeof(self) weakSelf = self;
    [self startLoading];
    [self reloadHistory];

    UINib *cellNib = [UINib nibWithNibName:@"TCMonitorHistoryTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:MONITOR_HISTORY_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    req = [[TCPerformanceHistoryRequest alloc] initWithServerID:_serverID
                                                           type:type
                                                      startTime:startTime
                                                        endTime:endTime
                                                           page:_pageIndex
                                                  amountPerPage:20];
    [req startWithSuccess:^(NSArray<TCPerformanceItem *> *perfArray) {
        [weakSelf stopLoading];
        [weakSelf.performanceArray addObjectsFromArray:perfArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
}

- (void) loadMoreHistory
{
    
}

- (IBAction) onTimeFilterButton:(id)sender
{
    NSLog(@"on time filter button");
    [_typeMenu closeAllComponentsAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _performanceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TCServerPerformance *performance = [_performanceArray objectAtIndex:indexPath.row];
    TCPerformanceItem *item = [_performanceArray objectAtIndex:indexPath.row];
    TCMonitorHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MONITOR_HISTORY_CELL_ID forIndexPath:indexPath];
    //[cell setPerformance:performance];
    [cell setPerformance:item];
    
    //TCMessage *message = [_messageArray objectAtIndex:indexPath.row];
    //TCMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MESSAGE_CELL_ID forIndexPath:indexPath];
    //[cell setMessage:message];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    return [[NSAttributedString alloc] initWithString:@"暂无消息" attributes:attributes];
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
    //return _modeMenuOptions.count;
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
    return [[NSAttributedString alloc] initWithString:self.typeMenuOptions[_selectedMenuIndex]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCSCALE(12) weight:UIFontWeightLight],
                                                        NSForegroundColorAttributeName: THEME_PLACEHOLDER_COLOR}];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component {
    NSLog(@"statusMenuOptions:%@",self.typeMenuOptions);
    for (NSString *opt in self.typeMenuOptions)
    {
        NSLog(@"opt:%@",opt);
    }
    NSLog(@"seelI:%ld",_selectedMenuIndex);
    return [[NSAttributedString alloc] initWithString:self.typeMenuOptions[_selectedMenuIndex]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCSCALE(12) weight:UIFontWeightRegular],
                                                        NSForegroundColorAttributeName: THEME_TEXT_COLOR}];
    
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ShapeSelectView *shapeSelectView = (ShapeSelectView *)view;
    if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[ShapeSelectView class]]) {
        shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShapeSelectView class]) owner:nil options:nil] firstObject];
    }
    //shapeSelectView.shapeView.sidesCount = row + 2;
    NSString *statusStr = self.typeMenuOptions[row];
    shapeSelectView.textLabel.text = statusStr;
    shapeSelectView.selected = _selectedMenuIndex == row;
    return shapeSelectView;
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self colorForRow:row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //[_keywordField resignFirstResponder];
    _selectedMenuIndex = row;
    [dropdownMenu reloadComponent:component];
    [dropdownMenu closeAllComponentsAnimated:YES];
    //[self doSearchWithKeyword:_keywordField.text mode:_modeSelectedIndex];
}

- (UIColor *)colorForRow:(NSInteger)row {
    return DROPDOWN_CELL_BG_COLOR;
}
@end
