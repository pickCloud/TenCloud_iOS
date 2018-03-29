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
#define APP_TABLE_CELL_ID   @"APP_TABLE_CELL_ID"

@interface TCAppTableViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *appArray;
- (void) generateFakeData;
- (void) updateAddAppButton;
- (void) onAddAppButton:(id)sender;
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
    [self generateFakeData];
    [self updateAddAppButton];
    
    UINib *appCellNib = [UINib nibWithNibName:@"TCAppTableViewCell" bundle:nil];
    [_tableView registerNib:appCellNib forCellReuseIdentifier:APP_TABLE_CELL_ID];
    
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
- (void) generateFakeData
{
    TCApp *app1 = [TCApp MR_createEntity];
    app1.appID = 1;
    app1.name = @"AppAPI";
    app1.status = @"初创建";
    app1.source = @"GitHub: AIUnicorn/10com";
    app1.createTime = [[NSDate date] timeIntervalSince1970]; //[NSDate timeIntervalSinceReferenceDate];
    app1.updateTime = [[NSDate date] timeIntervalSince1970]; //[NSDate timeIntervalSinceReferenceDate];
    //[app1.labels addObjectsFromArray:@[@"基础服务",@"应用组件"]];
    app1.labels = @[@"基础服务",@"应用组件"];
    app1.avatar = @"http://ou3t8uyol.bkt.clouddn.com/63A6B945-2C42-4E07-B004-D4318768165F";
    [_appArray addObject:app1];
    
    TCApp *app2 = [TCApp MR_createEntity];
    app2.appID = 2;
    app2.name = @"图片智能分析";
    app2.status = @"正常";
    app2.source = @"GitHub: AIUnicorn/ImageAI";
    app2.createTime = [NSDate timeIntervalSinceReferenceDate];
    app2.updateTime = [NSDate timeIntervalSinceReferenceDate];
    //[app2.labels addObjectsFromArray:@[@"普通项目"]];
    app2.labels = @[@"普通项目",@"常用工具"];
    [_appArray addObject:app2];
}

- (void) updateAddAppButton
{
    UIImage *addTmplImg = [UIImage imageNamed:@"app_add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addTmplImg forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddAppButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void) onAddAppButton:(id)sender
{
    
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
@end
