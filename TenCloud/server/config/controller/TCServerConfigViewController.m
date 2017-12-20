//
//  TCServerConfigViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerConfigViewController.h"
#import "TCServerConfigRequest.h"
#import "TCServerConfigTableViewCell.h"
#import "TCServerConfig+CoreDataClass.h"
#import "TCServerSystemInfo+CoreDataClass.h"
#import "TCServerSystemConfig+CoreDataClass.h"

#define SERVER_CONFIG_CELL_REUSE_ID     @"SERVER_CONFIG_CELL_REUSE_ID"

@interface TCServerConfigViewController ()
@property (nonatomic, assign)   NSInteger   serverID;
@property (nonatomic, weak)     IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableDictionary         *configDict;
@end

@implementation TCServerConfigViewController

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
        [weakSelf.configDict removeAllObjects];
        TCServerSystemConfig *sysConfig = config.system_info.config;
        NSString *os = sysConfig.os_name;
        NSString *type = sysConfig.os_type;
        NSInteger cpu = sysConfig.cpu;
        NSInteger memory = sysConfig.memory;
        if (!os || os.length == 0)
        {
            os = @"未知系统";
        }
        if (!type || type.length == 0)
        {
            type = @"未知系统类型";
        }
        NSString *cpuStr = [NSString stringWithFormat:@"%ld",cpu];
        CGFloat gigaByte = memory / 1024.0;
        NSString *memoryStr = [NSString stringWithFormat:@"%gG",gigaByte];
        [_configDict setObject:os forKey:@"操作系统"];
        [_configDict setObject:type forKey:@"系统类型"];
        [_configDict setObject:cpuStr forKey:@"CPU"];
        [_configDict setObject:memoryStr forKey:@"内存"];
        [weakSelf.tableView reloadData];
        NSLog(@"_configDict:%@",_configDict);
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
    [cell setSelected:YES];
    return cell;
    /*
    TCServerLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_LOG_CELL_REUSE_ID forIndexPath:indexPath];
    TCServerLog *log = [_logArray objectAtIndex:indexPath.row];
    [cell setLog:log];
    return cell;
     */
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
