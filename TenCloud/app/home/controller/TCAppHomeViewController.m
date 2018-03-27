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
#define APP_HOME_ICON_CELL_ID   @"APP_HOME_ICON_CELL_ID"
#define APP_HOME_APP_CELL_ID    @"APP_HOME_APP_CELL_ID"
#define APP_SECTION_HEADER_CELL_ID  @"APP_SECTION_HEADER_CELL_ID"

@interface TCAppHomeViewController ()
@property (nonatomic, weak) IBOutlet    UITableView         *tableView;
@property (nonatomic, weak) IBOutlet    UICollectionView    *iconView;
@property (nonatomic, strong)   NSMutableArray              *appArray;
@property (nonatomic, strong)   NSMutableArray              *deployArray;
@property (nonatomic, strong)   NSMutableArray              *serviceArray;
- (void) generateFakeData;
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
    app1.status = @"初创建";
    app1.source = @"GitHub: AIUnicorn/10com";
    app1.createTime = [NSDate timeIntervalSinceReferenceDate];
    app1.updateTime = [NSDate timeIntervalSinceReferenceDate];
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
    app2.labels = @[@"普通项目",@"组件",@"美国",@"常用工具",@"AI工具链"];
    [_appArray addObject:app2];
    
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
    
    TCService *service1 = [TCService MR_createEntity];
    service1.serviceID = 100;
    service1.name = @"service-exmaple";
    service1.status = @"成功";
    service1.clusterIP = @"10.43.249.244";
    //service1.outerIP = @"无";
    service1.loadBalancing = @"none";
    service1.port = @"80/TCP,443/TCP";
    service1.createTime = [NSDate timeIntervalSinceReferenceDate];
    [_serviceArray addObject:service1];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _appArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_HOME_APP_CELL_ID forIndexPath:indexPath];
    TCApp *app = [_appArray objectAtIndex:indexPath.row];
    [cell setApp:app];
    return cell;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    TCAppSectionHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:APP_SECTION_HEADER_CELL_ID];
    return header;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
