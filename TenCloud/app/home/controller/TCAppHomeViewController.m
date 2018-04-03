//
//  TCAppHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAppHomeViewController.h"
#import "TCAppHomeIconCell.h"
#import "TCApp+CoreDataClass.h"
#import "TCDeploy+CoreDataClass.h"
#import "TCService+CoreDataClass.h"
#import "TCAppTableViewCell.h"
#import "TCAppSectionHeaderCell.h"
#import "TCDeployTableViewCell.h"
#import "TCServiceTableViewCell.h"
#import "TCMessageButton.h"
#import "TCMessageTableViewController.h"
#import "TCAppProfileViewController.h"
#import "TCAppTableViewController.h"

#import "TCAddAppViewController.h"

#define APP_HOME_ICON_CELL_ID       @"APP_HOME_ICON_CELL_ID"
#define APP_HOME_APP_CELL_ID        @"APP_HOME_APP_CELL_ID"
#define APP_HOME_DEPLOY_CELL_ID     @"APP_HOME_DEPLOY_CELL_ID"
#define APP_HOME_SERVICE_CELL_ID    @"APP_HOME_SERVICE_CELL_ID"
#define APP_SECTION_HEADER_CELL_ID  @"APP_SECTION_HEADER_CELL_ID"

@interface TCAppHomeViewController ()
@property (nonatomic, weak) IBOutlet    UITableView         *tableView;
@property (nonatomic, weak) IBOutlet    UICollectionView    *iconView;
@property (nonatomic, strong)   NSMutableArray              *appArray;
@property (nonatomic, strong)   NSMutableArray              *deployArray;
@property (nonatomic, strong)   NSMutableArray              *serviceArray;
- (void) generateFakeData;
- (void) onMessageButton:(id)sender;
@end

@implementation TCAppHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"应用/服务";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    [self wr_setNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
    
    _appArray = [NSMutableArray new];
    _deployArray = [NSMutableArray new];
    _serviceArray = [NSMutableArray new];
    
    [self generateFakeData];
    
    UINib *iconCellNib = [UINib nibWithNibName:@"TCAppHomeIconCell" bundle:nil];
    [_iconView registerNib:iconCellNib forCellWithReuseIdentifier:APP_HOME_ICON_CELL_ID];
    UICollectionViewFlowLayout  *iconLayout = [[UICollectionViewFlowLayout alloc] init];
    iconLayout.itemSize = CGSizeMake(TCSCALE(72.92), TCSCALE(83.92));
    iconLayout.minimumInteritemSpacing = TCSCALE(0.0);
    iconLayout.minimumLineSpacing = TCSCALE(0.0);
    float iconX = 0;
    iconLayout.headerReferenceSize = CGSizeMake(iconX, iconX);
    iconLayout.footerReferenceSize = CGSizeMake(iconX, iconX);
    [_iconView setCollectionViewLayout:iconLayout];
    [_iconView reloadData];
    
    
    UINib *appCellNib = [UINib nibWithNibName:@"TCAppTableViewCell" bundle:nil];
    [_tableView registerNib:appCellNib forCellReuseIdentifier:APP_HOME_APP_CELL_ID];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"TCAppSectionHeaderCell" bundle:nil];
    [_tableView registerNib:sectionHeaderNib forCellReuseIdentifier:APP_SECTION_HEADER_CELL_ID];
    UINib *deployCellNib = [UINib nibWithNibName:@"TCDeployTableViewCell" bundle:nil];
    [_tableView registerNib:deployCellNib forCellReuseIdentifier:APP_HOME_DEPLOY_CELL_ID];
    UINib *serviceCellNib = [UINib nibWithNibName:@"TCServiceTableViewCell" bundle:nil];
    [_tableView registerNib:serviceCellNib forCellReuseIdentifier:APP_HOME_SERVICE_CELL_ID];
    
    TCMessageButton *msgButton = [TCMessageButton new];
    [msgButton addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *msgItem = [[UIBarButtonItem alloc] initWithCustomView:msgButton];
    self.navigationItem.rightBarButtonItem = msgItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCAppHomeIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:APP_HOME_ICON_CELL_ID forIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        [cell setName:@"有效应用" withAmount:8];
    }else if(indexPath.row == 1)
    {
        [cell setName:@"本周有效部署" withAmount:3];
    }else if(indexPath.row == 2)
    {
        [cell setName:@"有效Pods" withAmount:6];
    }else if(indexPath.row == 3)
    {
        [cell setName:@"独立容器" withAmount:3];
    }else if(indexPath.row == 4)
    {
        [cell setName:@"有效服务" withAmount:3];
    }
    return cell;
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        TCAppTableViewController *tableVC = [TCAppTableViewController new];
        [self.navigationController pushViewController:tableVC animated:YES];
    }else
    {
        [MBProgressHUD showError:@"暂无此页面" toView:nil];
    }
}

#pragma mark - extension
- (void) generateFakeData
{
    TCApp *app1 = [TCApp MR_createEntity];
    app1.appID = 1;
    app1.name = @"AppAPI";
    app1.status = 0;//@"初创建";
    app1.repos_https_url = @"GitHub: AIUnicorn/10com";
    app1.create_time = @"2018-01-01 12:00:00";
    //[[NSDate date] timeIntervalSince1970]; //[NSDate timeIntervalSinceReferenceDate];
    app1.update_time = @"2018-01-01 12:00:00";
    //[[NSDate date] timeIntervalSince1970]; //[NSDate timeIntervalSinceReferenceDate];
    //[app1.labels addObjectsFromArray:@[@"基础服务",@"应用组件"]];
    app1.labels = @[@"基础服务",@"应用组件"];
    app1.logo_url = @"http://ou3t8uyol.bkt.clouddn.com/63A6B945-2C42-4E07-B004-D4318768165F";
    [_appArray addObject:app1];
    
    TCApp *app2 = [TCApp MR_createEntity];
    app2.appID = 2;
    app2.name = @"图片智能分析";
    app2.status = 0;//@"正常";
    app2.logo_url = @"GitHub: AIUnicorn/ImageAI";
    app2.create_time = @"2018-01-01 12:00:00";
    //[NSDate timeIntervalSinceReferenceDate];
    app2.update_time = @"2018-01-01 12:00:00";
    //[NSDate timeIntervalSinceReferenceDate];
    //[app2.labels addObjectsFromArray:@[@"普通项目"]];
    app2.labels = @[@"普通项目",@"常用工具"];
    [_appArray addObject:app2];
    
    /*
    for (int i = 0; i < 10; i++)
    {
        TCApp *tmpApp = [TCApp MR_createEntity];
        tmpApp.appID = 10+i;
        tmpApp.name = @"图片智能分析";
        tmpApp.status = @"正常";
        tmpApp.source = @"GitHub: AIUnicorn/ImageAI";
        tmpApp.createTime = [NSDate timeIntervalSinceReferenceDate];
        tmpApp.updateTime = [NSDate timeIntervalSinceReferenceDate];
        //[app2.labels addObjectsFromArray:@[@"普通项目"]];
        tmpApp.labels = @[@"普通项目",@"组件",@"美国",@"常用工具"];
        [_appArray addObject:tmpApp];
    }
     */
    
    TCDeploy *dp1 = [TCDeploy MR_createEntity];
    dp1.deployID = 10;
    dp1.name = @"kubernetes-bootcamp";
    dp1.status = @"运行中";
    dp1.presetPod = 1;
    dp1.currentPod = 1;
    dp1.updatedPod = 1;
    dp1.availablePod = 1;
    dp1.runTime = 120;
    dp1.createTime = [NSDate timeIntervalSinceReferenceDate];
    [_deployArray addObject:dp1];
    
    for (int j = 0; j < 2; j++)
    {
        TCDeploy *dpj = [TCDeploy MR_createEntity];
        dpj.deployID = 10;
        dpj.name = @"kubernetes-bootcamp";
        dpj.status = @"运行中";
        dpj.presetPod = 1;
        dpj.currentPod = 1;
        dpj.updatedPod = 1;
        dpj.availablePod = 1;
        dpj.runTime = 120;
        dpj.createTime = [NSDate timeIntervalSinceReferenceDate];
        [_deployArray addObject:dpj];
    }
    
    TCService *service1 = [TCService MR_createEntity];
    service1.serviceID = 100;
    service1.name = @"service-exmaple";
    service1.status = @"成功";
    service1.clusterIP = @"10.43.249.244";
    service1.outerIP = @"102.93.39.111";
    service1.loadBalancing = @"none";
    service1.port = @"80/TCP,443/TCP";
    service1.createTime = [NSDate timeIntervalSinceReferenceDate];
    [_serviceArray addObject:service1];
}

- (void) onMessageButton:(id)sender
{
    TCAddAppViewController *addVC = [TCAddAppViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
    /*
    TCMessageTableViewController *msgVC = [TCMessageTableViewController new];
    [self.navigationController pushViewController:msgVC animated:YES];
     */
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
    {
        return _deployArray.count;
    }else if(section == 2)
    {
        return _serviceArray.count;
    }
    return _appArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
    {
        TCDeployTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_HOME_DEPLOY_CELL_ID forIndexPath:indexPath];
        TCDeploy *dp = [_deployArray objectAtIndex:indexPath.row];
        [cell setDeploy:dp];
        return cell;
    }else if(indexPath.section == 2)
    {
        TCServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_HOME_SERVICE_CELL_ID forIndexPath:indexPath];
        TCService *service = [_serviceArray objectAtIndex:indexPath.row];
        [cell setService:service];
        return cell;
    }
    TCAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_HOME_APP_CELL_ID forIndexPath:indexPath];
    TCApp *app = [_appArray objectAtIndex:indexPath.row];
    [cell setApp:app];
    return cell;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    __weak __typeof(self) weakSelf = self;
    TCAppSectionHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:APP_SECTION_HEADER_CELL_ID];
    if (section == 0)
    {
        [header setSectionTitle:@"热门应用" buttonName:@"更多"];
        [header setButtonBlock:^(TCAppSectionHeaderCell *cell) {
            TCAppTableViewController *tableVC = [TCAppTableViewController new];
            [weakSelf.navigationController pushViewController:tableVC animated:YES];
        }];
    }else if(section == 1)
    {
        [header setSectionTitle:@"最新部署" buttonName:@"更多"];
        [header setButtonBlock:^(TCAppSectionHeaderCell *cell) {
            
        }];
    }else if(section == 2)
    {
        [header setSectionTitle:@"最新服务" buttonName:@"更多"];
        [header setButtonBlock:^(TCAppSectionHeaderCell *cell) {
            
        }];
    }
    return header;
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
