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
#import "TCDeleteServerRequest.h"
#import "TCButtonTableViewCell.h"
#define SERVER_CONFIG_CELL_REUSE_ID     @"SERVER_CONFIG_CELL_REUSE_ID"
#define SERVER_STATE_CELL_REUSE_ID      @"SERVER_STATE_CELL_REUSE_ID"
#define SERVER_BUTTON_CELL_ID           @"SERVER_BUTTON_CELL_ID"
#define STATE_MAX_RETRY_TIMES           120

@interface TCServerInfoViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong) IBOutlet    UIView          *footerView;      //error when weak
@property (nonatomic, strong) IBOutlet    UIView          *stopFooterView;
@property (nonatomic, strong) IBOutlet    UIView          *rebootFooterView;
@property (nonatomic, strong)   IBOutlet    UITableView     *buttonTableView;
@property (nonatomic, strong)   TCServerConfig          *config;
@property (nonatomic, strong)   NSMutableArray          *configArray;
@property (nonatomic, strong)   TCServer                *server;
@property (nonatomic, assign)   NSInteger               retryTimes;
@property (nonatomic, strong)   NSMutableArray          *buttonDataArray;
- (IBAction) onRestartButton:(id)sender;
- (IBAction) onPowerOffButton:(id)sender;
- (IBAction) onStartButton:(id)sender;
- (IBAction) onDeleteButton:(id)sender;
- (void) updateFooterViewWithStatus:(NSString*)status;
- (void) udpateStatusLabel:(NSString*)status;
- (void) sendUpdateServerStateRequest;
@end

@implementation TCServerInfoViewController

- (instancetype) initWithServer:(TCServer*)server
{
    self = [super init];
    if (self)
    {
        _server = server;
        _retryTimes = 0;
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
    //_tableView.tableFooterView = _rebootFooterView;
    _buttonDataArray = [NSMutableArray new];
    UINib *buttonCellNib = [UINib nibWithNibName:@"TCButtonTableViewCell" bundle:nil];
    [_buttonTableView registerNib:buttonCellNib forCellReuseIdentifier:SERVER_BUTTON_CELL_ID];
    _tableView.tableFooterView = _buttonTableView;
    
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
            [weakSelf updateFooterViewWithStatus:status];
        } failure:^(NSString *message) {
            NSLog(@"message:%@",message);
        }];
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
    if (_buttonTableView == tableView)
    {
        NSLog(@"_button data array:%@",_buttonDataArray);
        return _buttonDataArray.count;
    }
    return _configArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _buttonTableView)
    {
        __weak __typeof(self) weakSelf = self;
        TCProfileButtonData *btnData = [_buttonDataArray objectAtIndex:indexPath.row];
        TCButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_BUTTON_CELL_ID forIndexPath:indexPath];
        btnData.buttonIndex = indexPath.row;
        [cell setData:btnData];
        cell.touchedBlock = ^(TCButtonTableViewCell *cell, NSInteger cellIndex, TCProfileButtonType type) {
            NSLog(@"cell button %ld touched",cellIndex);
            if (type == TCServerButtonStart)
            {
                [weakSelf onStartButton:nil];
            }else if (type == TCServerButtonRestart)
            {
                [weakSelf onRestartButton:nil];
            }else if(type == TCServerButtonStop)
            {
                [weakSelf onPowerOffButton:nil];
            }else if(type == TCServerButtonDelete)
            {
                [self onDeleteButton:nil];
            }
        };
        return cell;
    }
    
    TCServerInfoItem *infoItem = [_configArray objectAtIndex:indexPath.row];
    if (infoItem.cellType == TCInfoCellTypeStateLabel)
    {
        TCServerStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_STATE_CELL_REUSE_ID forIndexPath:indexPath];
        [cell setKey:infoItem.key value:infoItem.value];
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
    __weak __typeof(self) weakSelf = self;
    NSString *tip = @"确定重启这台服务器?";
    TCConfirmBlock block = ^(TCConfirmView *view){
        TCRebootServerRequest *request = [[TCRebootServerRequest alloc] initWithServerID:_server.serverID];
        [request startWithSuccess:^(NSString *status) {
            [weakSelf sendUpdateServerStateRequest];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    };
    [TCAlertController presentFromController:self
                                       title:tip
                           confirmButtonName:@"重启"
                                confirmBlock:block
                                 cancelBlock:nil];
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定重启这台服务器?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor grayColor];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"重启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TCRebootServerRequest *request = [[TCRebootServerRequest alloc] initWithServerID:_server.serverID];
        [request startWithSuccess:^(NSString *status) {
            [weakSelf sendUpdateServerStateRequest];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:restartAction];
    [alertController presentationController];
    [self presentViewController:alertController animated:YES completion:nil];
     */
}

- (IBAction) onPowerOffButton:(id)sender
{
    NSLog(@"on power off button");
    __weak __typeof(self) weakSelf = self;
    NSString *title = @"确定关闭这台服务器?";
    TCConfirmBlock block = ^(TCConfirmView *view){
        TCStopServerRequest *request = [[TCStopServerRequest alloc] initWithServerID:_server.serverID];
        [request startWithSuccess:^(NSString *status) {
            [weakSelf sendUpdateServerStateRequest];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    };
    [TCAlertController presentFromController:self
                                       title:title
                           confirmButtonName:@"关机"
                                confirmBlock:block
                                 cancelBlock:nil];
    
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定关闭这台服务器?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor grayColor];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *powerOffAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        TCStopServerRequest *request = [[TCStopServerRequest alloc] initWithServerID:_server.serverID];
        [request startWithSuccess:^(NSString *status) {
            [weakSelf sendUpdateServerStateRequest];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:powerOffAction];
    [alertController presentationController];
    [self presentViewController:alertController animated:YES completion:nil];
     */
}

- (IBAction) onStartButton:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    TCStartServerRequest *request = [[TCStartServerRequest alloc] initWithServerID:_server.serverID];
    [request startWithSuccess:^(NSString *status) {
        [weakSelf sendUpdateServerStateRequest];
    } failure:^(NSString *message) {
        
    }];
}

- (IBAction) onDeleteButton:(id)sender
{
    NSString *title = @"确定删除这台服务器?";
    TCConfirmBlock block = ^(TCConfirmView *view){
        [MMProgressHUD showWithStatus:@"删除中"];
        TCDeleteServerRequest *requst = [[TCDeleteServerRequest alloc] initWithServerID:_server.serverID];
        [requst startWithSuccess:^(NSString *status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEL_SERVER object:_server];
            [self.navigationController popViewControllerAnimated:YES];
            [MMProgressHUD dismissWithSuccess:@"删除成功" title:nil afterDelay:1.5];
        } failure:^(NSString *message) {
            [MMProgressHUD dismissWithError:message];
        }];
    };
    [TCAlertController presentFromController:self
                                       title:title
                           confirmButtonName:@"删除"
                                confirmBlock:block
                                 cancelBlock:nil];
    
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除这台服务器?"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor grayColor];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [MMProgressHUD showWithStatus:@"删除中"];
        TCDeleteServerRequest *requst = [[TCDeleteServerRequest alloc] initWithServerID:_server.serverID];
        [requst startWithSuccess:^(NSString *status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DEL_SERVER object:_server];
            [self.navigationController popViewControllerAnimated:YES];
            [MMProgressHUD dismissWithSuccess:@"删除成功" title:nil afterDelay:1.5];
        } failure:^(NSString *message) {
            [MMProgressHUD dismissWithError:message];
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController presentationController];
    [self presentViewController:alertController animated:YES completion:nil];
     */
}

- (void) updateFooterViewWithStatus:(NSString*)status
{
    NSLog(@"get status:%@",status);
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    if (status != nil)
    {
        [_buttonDataArray removeAllObjects];
        if ([status containsString:@"已停止"])
        {
            if ( currentCorp.isAdmin ||
                [currentCorp havePermissionForFunc:FUNC_ID_START_SERVER] )
            {
                TCProfileButtonData *data1 = [TCProfileButtonData new];
                data1.title = @"开机";
                data1.color = THEME_TINT_COLOR;
                data1.type = TCServerButtonStart;
                [_buttonDataArray addObject:data1];
            }
            
//            TCProfileButtonData *data2 = [TCProfileButtonData new];
//            data2.title = @"删除";
//            data2.color = STATE_ALERT_COLOR;
//            data2.type = TCServerButtonDelete;
//            [_buttonDataArray addObject:data2];
        }else if([status containsString:@"重启"])
        {
//            TCProfileButtonData *data2 = [TCProfileButtonData new];
//            data2.title = @"删除";
//            data2.color = STATE_ALERT_COLOR;
//            data2.type = TCServerButtonDelete;
//            [_buttonDataArray addObject:data2];
        }else if([status containsString:@"启动"])
        {
//            TCProfileButtonData *data2 = [TCProfileButtonData new];
//            data2.title = @"删除";
//            data2.color = STATE_ALERT_COLOR;
//            data2.type = TCServerButtonDelete;
//            [_buttonDataArray addObject:data2];
        }else if([status containsString:@"停止"])
        {
//            TCProfileButtonData *data2 = [TCProfileButtonData new];
//            data2.title = @"删除";
//            data2.color = STATE_ALERT_COLOR;
//            data2.type = TCServerButtonDelete;
//            [_buttonDataArray addObject:data2];
        }else
        {
            if ( currentCorp.isAdmin ||
                [currentCorp havePermissionForFunc:FUNC_ID_START_SERVER] )
            {
                TCProfileButtonData *data1 = [TCProfileButtonData new];
                data1.title = @"重启";
                data1.color = THEME_TINT_COLOR;
                data1.type = TCServerButtonRestart;
                [_buttonDataArray addObject:data1];
            }

            if ( currentCorp.isAdmin ||
                [currentCorp havePermissionForFunc:FUNC_ID_START_SERVER] )
            {
                TCProfileButtonData *data2 = [TCProfileButtonData new];
                data2.title = @"关机";
                data2.color = THEME_TINT_COLOR;
                data2.type = TCServerButtonStop;
                [_buttonDataArray addObject:data2];
            }
            
//            TCProfileButtonData *data3 = [TCProfileButtonData new];
//            data3.title = @"删除";
//            data3.color = STATE_ALERT_COLOR;
//            data3.type = TCServerButtonDelete;
//            [_buttonDataArray addObject:data3];
        }
        /*
        if ([status containsString:@"已停止"])
        {
            self.tableView.tableFooterView = self.stopFooterView;
            return;
        }else if([status containsString:@"重启"])
        {
            self.tableView.tableFooterView = self.rebootFooterView;
            return;
        }else if([status containsString:@"启动"])
        {
            self.tableView.tableFooterView = self.rebootFooterView;
            return;
        }else if([status containsString:@"停止"])
        {
            self.tableView.tableFooterView = self.rebootFooterView;
            return;
        }
         */
    }
    
    if ( currentCorp.isAdmin ||
        [currentCorp havePermissionForFunc:FUNC_ID_DEL_SERVER] )
    {
        TCProfileButtonData *data3 = [TCProfileButtonData new];
        data3.title = @"删除";
        data3.color = STATE_ALERT_COLOR;
        data3.type = TCServerButtonDelete;
        [_buttonDataArray addObject:data3];
    }
    
    [self.buttonTableView reloadData];
}

- (void) udpateStatusLabel:(NSString*)status
{
    NSIndexPath *path4 = [NSIndexPath indexPathForRow:4 inSection:0];
    TCServerStateTableViewCell *stateCell = [_tableView cellForRowAtIndexPath:path4];
    if (stateCell)
    {
        [stateCell setStateValue:status];
    }
}

- (void) sendUpdateServerStateRequest
{
    __weak __typeof(self) weakSelf = self;
    TCServerStatusRequest *statusReq = [[TCServerStatusRequest alloc] initWithInstanceID:_config.basic_info.instance_id];
    [statusReq startWithSuccess:^(NSString *status) {
        NSLog(@"status:%@",status);
        weakSelf.retryTimes ++;
        [weakSelf udpateStatusLabel:status];
        [weakSelf updateFooterViewWithStatus:status];
        if (weakSelf.retryTimes < STATE_MAX_RETRY_TIMES)
        {
            [weakSelf performSelector:@selector(sendUpdateServerStateRequest)
                           withObject:nil
                           afterDelay:1.0];
        }
    } failure:^(NSString *message) {
        NSLog(@"message:%@",message);
        weakSelf.retryTimes ++;
        [weakSelf performSelector:@selector(sendUpdateServerStateRequest)
                       withObject:nil
                       afterDelay:1.5];
    }];
}
@end
