//
//  TCServerInfoViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerInfoViewController.h"
#import "TCServerConfigRequest.h"
#import "TCServerConfig+CoreDataClass.h"
#import "TCServerBasicInfo+CoreDataClass.h"
#import "TCServer+CoreDataClass.h"
#import "TCServerConfigTableViewCell.h"
#import "TCServerStateTableViewCell.h"
#import "TCServerInfoItem.h"
#import "TCServerStatusRequest.h"
#import "TCRebootServerRequest.h"
#import "TCStopServerRequest.h"
#import "TCStartServerRequest.h"
#define SERVER_CONFIG_CELL_REUSE_ID     @"SERVER_CONFIG_CELL_REUSE_ID"
#define SERVER_STATE_CELL_REUSE_ID      @"SERVER_STATE_CELL_REUSE_ID"

@interface TCServerInfoViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UIView          *footerView;
@property (nonatomic, weak) IBOutlet    UIView          *stopFooterView;
@property (nonatomic, weak) IBOutlet    UIView          *rebootFooterView;
@property (nonatomic, strong)   TCServerConfig          *config;
@property (nonatomic, strong)   NSMutableArray          *configArray;
@property (nonatomic, strong)   TCServer                *server;
- (IBAction) onRestartButton:(id)sender;
- (IBAction) onPowerOffButton:(id)sender;
- (IBAction) onStartButton:(id)sender;
- (IBAction) onDeleteButton:(id)sender;
@end

@implementation TCServerInfoViewController

- (instancetype) initWithServer:(TCServer*)server
{
    self = [super init];
    if (self)
    {
        _server = server;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _configArray = [NSMutableArray new];
    UINib *configCellNib = [UINib nibWithNibName:@"TCServerConfigTableViewCell" bundle:nil];
    [_tableView registerNib:configCellNib forCellReuseIdentifier:SERVER_CONFIG_CELL_REUSE_ID];
    UINib *stateCellNib = [UINib nibWithNibName:@"TCServerStateTableViewCell" bundle:nil];
    [_tableView registerNib:stateCellNib forCellReuseIdentifier:SERVER_STATE_CELL_REUSE_ID];
    //_tableView.tableFooterView = _footerView;
    //_tableView.tableFooterView = _stopFooterView;
    _tableView.tableFooterView = _rebootFooterView;
    
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCServerConfigRequest *request = [[TCServerConfigRequest alloc] initWithServerID:_server.serverID];
    [request startWithSuccess:^(TCServerConfig *config) {
        weakSelf.config = config;
        [weakSelf stopLoading];
        TCServerBasicInfo *info = config.basic_info;
        NSString *name = info.name ? info.name : @"";
        NSString *clusterName = info.cluster_name ? info.cluster_name : @"";
        NSString *address = info.address ? info.address : @"";
        NSString *ip = info.public_ip ? info.public_ip : @"";
        NSString *status = info.machine_status ? info.machine_status : @"";
        NSString *time = info.created_time ? info.created_time : @"";
        TCServerInfoItem *item1 = [[TCServerInfoItem alloc] initWithKey:@"名称" value:name];
        TCServerInfoItem *item2 = [[TCServerInfoItem alloc] initWithKey:@"服务商" value:clusterName];
        TCServerInfoItem *item3 = [[TCServerInfoItem alloc] initWithKey:@"地址" value:address];
        TCServerInfoItem *item4 = [[TCServerInfoItem alloc] initWithKey:@"IP" value:ip];
        TCServerInfoItem *item5 = [[TCServerInfoItem alloc] initWithKey:@"状态" value:status
                                   type:TCInfoCellTypeStateLabel];
        TCServerInfoItem *item6 = [[TCServerInfoItem alloc] initWithKey:@"添加时间" value:time];
        [_configArray addObject:item1];
        [_configArray addObject:item2];
        [_configArray addObject:item3];
        [_configArray addObject:item4];
        [_configArray addObject:item5];
        [_configArray addObject:item6];
        [weakSelf.tableView reloadData];
        
        TCServerStatusRequest *statusReq = [[TCServerStatusRequest alloc] initWithInstanceID:_config.basic_info.instance_id];
        [statusReq startWithSuccess:^(NSString *status) {
            NSLog(@"status:%@",status);
        } failure:^(NSString *message) {
            NSLog(@"message:%@",message);
        }];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
    
    //TCServerStatusRequest *statusReq = [[TCServerStatusRequest alloc] initWithInstanceID:_server.instance_name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _configArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerInfoItem *infoItem = [_configArray objectAtIndex:indexPath.row];
    if (infoItem.cellType == TCInfoCellTypeStateLabel)
    {
        TCServerStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_STATE_CELL_REUSE_ID forIndexPath:indexPath];
        //[cell setKey:infoItem.key value:infoItem.value];
        [cell setKey:infoItem.key value:@"已停止"];
        return cell;
    }
    TCServerConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CONFIG_CELL_REUSE_ID forIndexPath:indexPath];
    
    [cell setKey:infoItem.key value:infoItem.value];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - extension
- (IBAction) onRestartButton:(id)sender
{
    NSLog(@"on reboot button");
    /*
    NSLog(@"on reestart button");
    TCRebootServerRequest *request = [[TCRebootServerRequest alloc] initWithServerID:_server.serverID];
    [request startWithSuccess:^(NSString *status) {
        
    } failure:^(NSString *message) {
        
    }];
     
    TCStartServerRequest *request = [[TCStartServerRequest alloc] initWithServerID:_server.serverID];
    [request startWithSuccess:^(NSString *status) {
        
    } failure:^(NSString *message) {
        
    }];
     */
}

- (IBAction) onPowerOffButton:(id)sender
{
    NSLog(@"on power off button");
    /*
    TCStopServerRequest *request = [[TCStopServerRequest alloc] initWithServerID:_server.serverID];
    [request startWithSuccess:^(NSString *status) {
        
    } failure:^(NSString *message) {
        
    }];
     */
    
}

- (IBAction) onStartButton:(id)sender
{
    NSLog(@"on start button");
}

- (IBAction) onDeleteButton:(id)sender
{
    NSLog(@"on delete button");
}
@end
