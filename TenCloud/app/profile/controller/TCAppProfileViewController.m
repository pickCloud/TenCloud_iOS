//
//  TCAppProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAppProfileViewController.h"
#import "TCAppStatusLabel.h"
#import "TCApp+CoreDataClass.h"
#import "TCTagLabelCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "TCDeploy+CoreDataClass.h"
#import "TCService+CoreDataClass.h"
#import "TCMirror+CoreDataClass.h"
#import "TCTask+CoreDataClass.h"
#import "TCAppProfileDeployCell.h"
#import "TCAppProfileServiceCell.h"
#import "TCAppProfileSectionHeader.h"
#import "TCAppProfileMirrorCell.h"
#import "TCAppProfileSection3Header.h"
#define APP_PROF_TAG_CELL_ID     @"APP_PROF_TAG_CELL_ID"
#define APP_PROF_DEPLOY_CELL_ID  @"APP_PROF_DEPLOY_CELL_ID"
#define APP_PROF_SERVICE_CELL_ID @"APP_PROF_SERVICE_CELL_ID"
#define APP_PROF_MIRROR_CELL_ID  @"APP_PROF_MIRROR_CELL_ID"
#define APP_PROF_SEC_HEADER_ID   @"APP_PROF_SEC_HEADER_ID"
#define APP_PROF_SEC3_HEADER_ID  @"APP_PROF_SEC3_HEADER_ID"

@interface TCAppProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)   TCApp                       *app;
@property (nonatomic, strong)   NSMutableArray              *deployArray;
@property (nonatomic, strong)   NSMutableArray              *serviceArray;
@property (nonatomic, strong)   NSMutableArray              *mirrorArray;
@property (nonatomic, strong)   NSMutableArray              *taskArray;
@property (nonatomic, weak) IBOutlet    UITableView         *tableView;
@property (nonatomic, weak) IBOutlet    UIImageView         *avatarView;
@property (nonatomic, weak) IBOutlet    UILabel             *nameLabel;
@property (nonatomic, weak) IBOutlet    UICollectionView    *tagView;
@property (nonatomic, weak) IBOutlet    TCAppStatusLabel    *statusLabel;
- (void) createFakeData;
- (void) updateHeaderUI;
- (IBAction) onHeaderNextButton:(id)sender;
@end

@implementation TCAppProfileViewController

- (id) initWithApp:(TCApp *)app
{
    self = [super init];
    if (self)
    {
        _app = app;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"应用详情";
    _deployArray = [NSMutableArray new];
    _serviceArray = [NSMutableArray new];
    _mirrorArray = [NSMutableArray new];
    _taskArray = [NSMutableArray new];
    [self createFakeData];
    
    UINib *labelCellNib = [UINib nibWithNibName:@"TCTagLabelCell" bundle:nil];
    [_tagView registerNib:labelCellNib forCellWithReuseIdentifier:APP_PROF_TAG_CELL_ID];
    UICollectionViewFlowLayout *layout = nil;
    layout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:8.0];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_tagView setCollectionViewLayout:layout];
    
    UINib *deployCellNib = [UINib nibWithNibName:@"TCAppProfileDeployCell" bundle:nil];
    [_tableView registerNib:deployCellNib forCellReuseIdentifier:APP_PROF_DEPLOY_CELL_ID];
    UINib *serviceCellNib = [UINib nibWithNibName:@"TCAppProfileServiceCell" bundle:nil];
    [_tableView registerNib:serviceCellNib forCellReuseIdentifier:APP_PROF_SERVICE_CELL_ID];
    UINib *mirrorCellNib = [UINib nibWithNibName:@"TCAppProfileMirrorCell" bundle:nil];
    [_tableView registerNib:mirrorCellNib forCellReuseIdentifier:APP_PROF_MIRROR_CELL_ID];
    UINib *headerCellNib = [UINib nibWithNibName:@"TCAppProfileSectionHeader" bundle:nil];
    [_tableView registerNib:headerCellNib forCellReuseIdentifier:APP_PROF_SEC_HEADER_ID];
    UINib *header3CellNib = [UINib nibWithNibName:@"TCAppProfileSection3Header" bundle:nil];
    [_tableView registerNib:header3CellNib forCellReuseIdentifier:APP_PROF_SEC3_HEADER_ID];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self updateHeaderUI];
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
- (void) createFakeData
{
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
    service1.outerIP = @"102.93.39.111";
    service1.loadBalancing = @"none";
    service1.port = @"80/TCP,443/TCP";
    service1.createTime = [NSDate timeIntervalSinceReferenceDate];
    [_serviceArray addObject:service1];
    
    TCMirror *mirror1 = [TCMirror MR_createEntity];
    mirror1.mirrorID = 1;
    mirror1.name = @"CentOS";
    mirror1.version = @"v 9.0.5";
    mirror1.updateTime = [[NSDate date] timeIntervalSince1970];
    [_mirrorArray addObject:mirror1];
    
    TCMirror *mirror2 = [TCMirror MR_createEntity];
    mirror2.mirrorID = 1;
    mirror2.name = @"Ubuntu";
    mirror2.version = @"v 4.2.3";
    mirror2.updateTime = [[NSDate date] timeIntervalSince1970];
    [_mirrorArray addObject:mirror2];
    
    TCMirror *mirror3 = [TCMirror MR_createEntity];
    mirror3.mirrorID = 1;
    mirror3.name = @"Windows Server 2010";
    mirror3.version = @"v 3.2.3";
    mirror3.updateTime = [[NSDate date] timeIntervalSince1970];
    [_mirrorArray addObject:mirror3];
    
    TCTask *task1 = [TCTask MR_createEntity];
    task1.name = @"构建镜像 - Djago v1.0.5";
    task1.progress = 0.8;
    task1.startTime = [[NSDate date] timeIntervalSince1970];
    task1.endTime = [[NSDate date] timeIntervalSince1970];
    task1.status = @"进行中";
    [_taskArray addObject:task1];
    
    TCTask *task2 = [TCTask MR_createEntity];
    task2.name = @"kubernetes部署 - Djago v1.0.5";
    task2.progress = 0.8;
    task2.startTime = [[NSDate date] timeIntervalSince1970];
    task2.endTime = [[NSDate date] timeIntervalSince1970];
    task2.status = @"成功";
    [_taskArray addObject:task2];
    
    TCTask *task3 = [TCTask MR_createEntity];
    task3.name = @"docker原生部署 - Djago v1.0.5";
    task3.progress = 0.8;
    task3.startTime = [[NSDate date] timeIntervalSince1970];
    task3.endTime = [[NSDate date] timeIntervalSince1970];
    task3.status = @"失败";
    [_taskArray addObject:task3];
    
}

- (void) updateHeaderUI
{
    _nameLabel.text = _app.name;
    [_statusLabel setStatus:_app.status];
    [_tagView reloadData];
}

- (IBAction) onHeaderNextButton:(id)sender
{
    
}

#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _app.labels.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCTagLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:APP_PROF_TAG_CELL_ID forIndexPath:indexPath];
    NSString *tagName = [_app.labels objectAtIndex:indexPath.row];
    [cell setName:tagName];
    [cell setSelected:NO];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [_app.labels objectAtIndex:indexPath.row];
    if (text == nil || text.length == 0)
    {
        text = @"默认";
    }
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TCFont(10.0)} context:nil].size;
    return CGSizeMake(textSize.width + 6, textSize.height + 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        NSLog(@"_deploy count:%ld",_deployArray.count);
        return _deployArray.count;
    }else if(section == 1)
    {
        NSLog(@"_service count:%ld",_serviceArray.count);
        return _serviceArray.count;
    }else if(section == 2)
    {
        return _mirrorArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        TCAppProfileDeployCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_PROF_DEPLOY_CELL_ID forIndexPath:indexPath];
        TCDeploy *dp = [_deployArray objectAtIndex:indexPath.row];
        [cell setDeploy:dp];
        return cell;
    }else if(indexPath.section == 1)
    {
        TCAppProfileServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_PROF_SERVICE_CELL_ID forIndexPath:indexPath];
        TCService *service = [_serviceArray objectAtIndex:indexPath.row];
        [cell setService:service];
        return cell;
    }
    TCAppProfileMirrorCell *cell = [tableView dequeueReusableCellWithIdentifier:APP_PROF_MIRROR_CELL_ID forIndexPath:indexPath];
    TCMirror *mirror = [_mirrorArray objectAtIndex:indexPath.row];
    BOOL showSeperator = indexPath.row != (_mirrorArray.count - 1);
    [cell setMirror:mirror showSeperator:showSeperator];
    return cell;

}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section <= 1)
    {
        TCAppProfileSectionHeader *header = [tableView dequeueReusableCellWithIdentifier:APP_PROF_SEC_HEADER_ID];
        if (section == 0)
        {
            [header setSectionTitle:@"部署"];
        }else if(section == 1)
        {
            [header setSectionTitle:@"服务"];
        }
        return header;
    }
    TCAppProfileSection3Header *header = [tableView dequeueReusableCellWithIdentifier:APP_PROF_SEC3_HEADER_ID];
    if (section == 2)
    {
        [header setSectionTitle:@"镜像及版本"];
    }else
    {
        [header setSectionTitle:@"任务"];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section <= 1)
    {
        return TCSCALE(30);
    }
    return TCSCALE(41);
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <= 1)
    {
        return NO;
    }
    return YES;
}
@end
