//
//  TCAppTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAppTableViewController.h"
#import "TCAppTableViewCell.h"
#import "TCApp+CoreDataClass.h"
#import "TCAppProfileViewController.h"
#import "TCAppFilterViewController.h"
#import "TCAddAppViewController.h"
#import "TCDataSync.h"
#import "TCAppListRequest.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#define APP_TABLE_CELL_ID   @"APP_TABLE_CELL_ID"

@interface TCAppTableViewController ()<TCDataSyncDelegate,DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *appArray;
- (void) generateFakeData;
- (void) reloadAppArray;
- (void) updateAddAppButton;
- (void) onAddAppButton:(id)sender;
- (void) onReloadAppNotification:(id)sender;
- (IBAction) onFilterButton:(id)sender;
@end

@implementation TCAppTableViewController

- (id) init
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
    self.title = @"应用列表";
    _appArray = [NSMutableArray new];
    //[self generateFakeData];
    [self updateAddAppButton];
    
    UINib *appCellNib = [UINib nibWithNibName:@"TCAppTableViewCell" bundle:nil];
    [_tableView registerNib:appCellNib forCellReuseIdentifier:APP_TABLE_CELL_ID];
    [[TCDataSync shared] addPermissionChangedObserver:self];
    
    [self startLoading];
    [self reloadAppArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReloadAppNotification:)
                                                 name:NOTIFICATION_MODIFY_APP
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReloadAppNotification:) name:NOTIFICATION_ADD_APP
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[TCDataSync shared] removePermissionChangedObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) generateFakeData
{
    TCApp *app1 = [TCApp MR_createEntity];
    app1.appID = 1;
    app1.name = @"AppAPI";
    app1.status = 0;//@"初创建";
    app1.repos_https_url = @"GitHub: AIUnicorn/10com";
    app1.create_time = @"2018-01-01 12:00:00";//[[NSDate date] timeIntervalSince1970]; //[NSDate timeIntervalSinceReferenceDate];
    app1.update_time = @"2018-01-01 12:00:00";//[[NSDate date] timeIntervalSince1970]; //[NSDate timeIntervalSinceReferenceDate];
    //[app1.labels addObjectsFromArray:@[@"基础服务",@"应用组件"]];
    app1.labels = @[@"基础服务",@"应用组件"];
    app1.logo_url = @"http://ou3t8uyol.bkt.clouddn.com/63A6B945-2C42-4E07-B004-D4318768165F";
    [_appArray addObject:app1];
    
    TCApp *app2 = [TCApp MR_createEntity];
    app2.appID = 2;
    app2.name = @"图片智能分析";
    app2.status = 1;//@"正常";
    app2.repos_https_url = @"GitHub: AIUnicorn/ImageAI";
    app2.create_time = @"2018-01-01 12:00:00";//[NSDate timeIntervalSinceReferenceDate];
    app2.update_time = @"2018-01-01 12:00:00";//[NSDate timeIntervalSinceReferenceDate];
    //[app2.labels addObjectsFromArray:@[@"普通项目"]];
    app2.labels = @[@"普通项目",@"常用工具"];
    [_appArray addObject:app2];
}

- (void) reloadAppArray
{
    __weak __typeof(self) weakSelf = self;
    TCAppListRequest *req = [TCAppListRequest new];
    [req startWithSuccess:^(NSArray<TCApp *> *appArray) {
        [weakSelf.appArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.appArray addObjectsFromArray:appArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (void) updateAddAppButton
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    if (currentCorp.isAdmin || [currentCorp havePermissionForFunc:FUNC_ID_ADD_APP])
    {
        UIImage *addTmplImg = [UIImage imageNamed:@"app_add"];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:addTmplImg forState:UIControlStateNormal];
        [addButton sizeToFit];
        [addButton addTarget:self action:@selector(onAddAppButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        self.navigationItem.rightBarButtonItem = addItem;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) onAddAppButton:(id)sender
{
    TCAddAppViewController *addVC = [TCAddAppViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void) onAddAppNotification:(id)sender
{
    [self reloadAppArray];
}

- (IBAction) onFilterButton:(id)sender
{
    NSLog(@"on filter button");
    NSArray *tagArray = @[@"普通项目",@"基础服务",@"应用组件"];
    TCAppFilterViewController *filterVC = [[TCAppFilterViewController alloc] initWithProviderArray:tagArray];
    [self presentViewController:filterVC animated:NO completion:nil];
    /*
    NSArray *providers = [[TCConfiguration shared] providerArray];
    TCSearchFilterViewController *filterVC = [[TCSearchFilterViewController alloc] initWithProviderArray:providers];
    [self presentViewController:filterVC animated:NO completion:nil];
     */
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _appArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_TABLE_CELL_ID forIndexPath:indexPath];
    TCApp *app = [_appArray objectAtIndex:indexPath.row];
    [cell setApp:app];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        TCApp *app = [_appArray objectAtIndex:indexPath.row];
        TCAppProfileViewController *profileVC = [[TCAppProfileViewController alloc] initWithApp:app];
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}


#pragma mark - DZNEmptyDataSetSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"app_no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(12.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR2 forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"对不起，你还没有任何应用" attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    BOOL canAdd = currentCorp.isAdmin ||
    [currentCorp havePermissionForFunc:FUNC_ID_ADD_APP] ||
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
    [currentCorp havePermissionForFunc:FUNC_ID_ADD_APP] ||
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

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    TCAddAppViewController *addVC = [TCAddAppViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}


#pragma mark - TCDataSyncDelegate
- (void) dataSync:(TCDataSync*)sync permissionChanged:(NSInteger)changed
{
    [self updateAddAppButton];
}
@end
