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
#import "TCServerConfigTableViewCell.h"
#define SERVER_CONFIG_CELL_REUSE_ID     @"SERVER_CONFIG_CELL_REUSE_ID"

@interface TCServerInfoViewController ()
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableDictionary         *configDict;
@end

@implementation TCServerInfoViewController

- (instancetype) initWithID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _configDict = [NSMutableDictionary new];
    UINib *configCellNib = [UINib nibWithNibName:@"TCServerConfigTableViewCell" bundle:nil];
    [_tableView registerNib:configCellNib forCellReuseIdentifier:SERVER_CONFIG_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCServerConfigRequest *request = [[TCServerConfigRequest alloc] initWithServerID:_serverID];
    [request startWithSuccess:^(TCServerConfig *config) {
        [weakSelf stopLoading];
        TCServerBasicInfo *info = config.basic_info;
        NSString *name = info.name ? info.name : @"";
        NSString *clusterName = info.cluster_name ? info.cluster_name : @"";
        NSString *address = info.address ? info.address : @"";
        NSString *ip = info.public_ip ? info.public_ip : @"";
        NSString *status = info.machine_status ? info.machine_status : @"";
        NSString *time = info.created_time ? info.created_time : @"";
        [_configDict setObject:name forKey:@"名称"];
        [_configDict setObject:clusterName forKey:@"服务器"];
        [_configDict setObject:address forKey:@"地址"];
        [_configDict setObject:ip forKey:@"IP"];
        [_configDict setObject:status forKey:@"状态"];
        [_configDict setObject:time forKey:@"添加时间"];
        [weakSelf.tableView reloadData];
        NSLog(@"info_config_dict:%@",_configDict);
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
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
    return _configDict.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CONFIG_CELL_REUSE_ID forIndexPath:indexPath];
    NSString *key = [[_configDict allKeys] objectAtIndex:indexPath.row];
    NSString *value = [_configDict valueForKey:key];
    [cell setKey:key value:value];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
