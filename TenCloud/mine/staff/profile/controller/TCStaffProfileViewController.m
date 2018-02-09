//
//  TCStaffProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/7.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCStaffProfileViewController.h"
#import "TCStaffProfileTableViewCell.h"
#import "TCServerInfoItem.h"
#import "TCStaff+CoreDataClass.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TCButtonTableViewCell.h"
#import "TCProfileButtonData.h"
#import "TCUserPermissionRequest.h"
#import "TCPermissionViewController.h"
#import "TCEditingPermission.h"
#import "TCTemplate+CoreDataClass.h"
#import "TCAcceptJoinRequest.h"
#import "TCRejectJoinRequest.h"
#import "TCRemoveStaffRequest.h"
#import "TCChangeAdminViewController.h"
#import "TCLeaveCorpRequest.h"
#import "TCPersonHomeViewController.h"
#import "TCMessageManager.h"
#import "TCDataSync.h"

#define STAFF_PROFILE_CELL_ID       @"STAFF_PROFILE_CELL_ID"
#define STAFF_BUTTON_CELL_ID        @"STAFF_BUTTON_CELL_ID"

@interface TCStaffProfileViewController ()<TCCurrentCorpDelegate,TCDataSyncDelegate>
@property (nonatomic, strong)   TCStaff         *staff;
@property (nonatomic, strong)   TCTemplate      *userTemplate;
@property (nonatomic, strong)   NSMutableArray  *rowDataArray;
@property (nonatomic, strong)   NSMutableArray  *buttonDataArray;
@property (nonatomic, weak)     IBOutlet    UITableView     *tableView;
@property (nonatomic, weak)     IBOutlet    UIImageView     *avatarView;
@property (nonatomic, weak)     IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak)     IBOutlet    UILabel         *phoneLabel;
@property (nonatomic, weak)     IBOutlet    UITableView     *buttonTableView;
- (void) updateUI;
- (void) reloadUserPermission;
@end

@implementation TCStaffProfileViewController

- (instancetype) initWithStaff:(TCStaff *)staff
{
    self = [super init];
    if (self)
    {
        _staff = staff;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工详情";
    
    _buttonDataArray = [NSMutableArray new];
    //if (_staff.is_admin)
    
    UINib *buttonCellNib = [UINib nibWithNibName:@"TCButtonTableViewCell" bundle:nil];
    [_buttonTableView registerNib:buttonCellNib forCellReuseIdentifier:STAFF_BUTTON_CELL_ID];
    
    _rowDataArray = [NSMutableArray new];
    UINib *cellNib = [UINib nibWithNibName:@"TCStaffProfileTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:STAFF_PROFILE_CELL_ID];
    _tableView.tableFooterView = _buttonTableView;
    
    TCServerInfoItem *item0 = [TCServerInfoItem new];
    item0.key = @"身份证号";
    BOOL idCardPermission = [[TCCurrentCorp shared] havePermissionForFunc:FUNC_ID_STAFF_IDCARD];
    BOOL visable = [[TCCurrentCorp shared] isAdmin] || idCardPermission;
    NSString *idCardStr = _staff.id_card;
    if (idCardStr == nil || idCardStr.length == 0)
    {
        idCardStr = @"";
    }
    /*
    if (!visable)
    {
        if (idCardStr && idCardStr.length >= 18)
        {
            NSRange preRange = NSMakeRange(0, 5);
            NSString *preStr = [idCardStr substringWithRange:preRange];
            NSRange endRange = NSMakeRange(idCardStr.length - 4, 3);
            NSString *endStr = [idCardStr substringWithRange:endRange];
            idCardStr = [NSString stringWithFormat:@"%@**********%@",preStr,endStr];
        }
    }
    item0.value = idCardStr;
    [_rowDataArray addObject:item0];
     */
    if (visable)
    {
        item0.value = idCardStr;
        [_rowDataArray addObject:item0];
    }
    
    TCServerInfoItem *item1 = [TCServerInfoItem new];
    item1.key = @"申请时间";
    NSString *createTime = _staff.create_time;
    if (createTime && createTime.length > 11)
    {
        NSRange dateRange = NSMakeRange(0, 10);
        createTime = [createTime substringWithRange:dateRange];
    }
    item1.value = createTime;
    [_rowDataArray addObject:item1];
    
    TCServerInfoItem *item3 = [TCServerInfoItem new];
    item3.key = @"加入时间";
    NSString *updateTime = _staff.update_time;
    /*
    if (_staff.status == STAFF_STATUS_REJECT ||
        _staff.status == STAFF_STATUS_PENDING)
    {
        updateTime = @"";
    }
    if (updateTime && updateTime.length > 11)
    {
        NSRange dateRange = NSMakeRange(0, 10);
        updateTime = [updateTime substringWithRange:dateRange];
    }
     */
    item3.value = updateTime;
    [_rowDataArray addObject:item3];
    
    TCServerInfoItem *item4 = [TCServerInfoItem new];
    item4.key = @"状态";
    if (_staff.status == STAFF_STATUS_REJECT)
    {
        item4.value = @"审核不通过";
    }else if(_staff.status == STAFF_STATUS_PENDING)
    {
        item4.value = @"待审核";
    }else
    {
        item4.value = @"审核通过";
    }
    [_rowDataArray addObject:item4];
    [self.tableView reloadData];
    
    [self updateUI];
    
    _nameLabel.text = _staff.name;
    NSURL *avatarURL = [NSURL URLWithString:_staff.image_url];
    UIImage *defaultAvatar = [UIImage imageNamed:@"default_avatar"];
    [_avatarView sd_setImageWithURL:avatarURL placeholderImage:defaultAvatar];
    _phoneLabel.text = _staff.mobile;
    
    if (_staff.status == STAFF_STATUS_PASS ||
        _staff.status == STAFF_STATUS_FOUNDER )
    {
        [self reloadUserPermission];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:NOTIFICATION_CHANGE_ADMIN
                                               object:nil];
    [[TCCurrentCorp shared] addObserver:self];
    [[TCDataSync shared] addPermissionChangedObserver:self];
}

- (void) dealloc
{
    [[TCCurrentCorp shared] removeObserver:self];
    [[TCDataSync shared] removePermissionChangedObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        return _buttonDataArray.count;
    }
    return _rowDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _buttonTableView)
    {
        __weak __typeof(self) weakSelf = self;
        TCProfileButtonData *btnData = [_buttonDataArray objectAtIndex:indexPath.row];
        TCButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STAFF_BUTTON_CELL_ID forIndexPath:indexPath];
        btnData.buttonIndex = indexPath.row;
        [cell setData:btnData];
        cell.touchedBlock = ^(TCButtonTableViewCell *cell, NSInteger cellIndex, TCProfileButtonType type) {
            NSLog(@"cell button %ld touched",cellIndex);
            if (type == TCProfileButtonViewPermission)
            {
                NSLog(@"查看权限");
                
                if (_staff.is_admin)
                //if ([[TCCurrentCorp shared] isAdmin])
                {
                    NSLog(@"for admin");
                    [[TCEditingPermission shared] resetForAdmin];
                }else
                {
                    NSLog(@"not for admin");
                    [[TCEditingPermission shared] reset];
                    [[TCEditingPermission shared] setTemplate:_userTemplate];
                    NSLog(@"check per %@",_userTemplate.access_servers);
                    [[TCEditingPermission shared] readyForPreview];
                }
                /*
                [[TCEditingPermission shared] reset];
                [[TCEditingPermission shared] setTemplate:_userTemplate];
                [[TCEditingPermission shared] readyForPreview];
                */
                
                TCPermissionViewController *perVC = [TCPermissionViewController new];
                perVC.userID = (NSInteger)_staff.uid;
                perVC.state = PermissionVCPreviewPermission;
                perVC.tmpl = _userTemplate;
                perVC.modifiedBlock = ^(TCPermissionViewController *vc) {
                    //TCEditingPermission *perm = [TCEditingPermission shared];
                    //weakSelf.userTemplate.access_servers = perm.serverPermissionIDString;
                    //weakSelf.userTemplate.access_filehub = perm.filePermissionIDString;
                    //weakSelf.userTemplate.access_projects = perm.projectPermissionIDString;
                    //weakSelf.userTemplate.permissions = perm.permissionIDString;
                };
                [self presentViewController:perVC animated:YES completion:nil];
            }else if(type == TCProfileButtonSetPermission)
            {
                NSLog(@"设置权限");
                [[TCEditingPermission shared] reset];
                [[TCEditingPermission shared] setTemplate:_userTemplate];
                TCPermissionViewController *perVC = [TCPermissionViewController new];
                perVC.userID = _staff.uid;
                perVC.state = PermissionVCModifyUserPermission;
                perVC.tmpl = _userTemplate;
                perVC.modifiedBlock = ^(TCPermissionViewController *vc) {
                    TCEditingPermission *perm = [TCEditingPermission shared];
                    weakSelf.userTemplate.access_servers = perm.serverPermissionIDString;
                    weakSelf.userTemplate.access_filehub = perm.filePermissionIDString;
                    weakSelf.userTemplate.access_projects = perm.projectPermissionIDString;
                    weakSelf.userTemplate.permissions = perm.permissionIDString;
                };
                [self presentViewController:perVC animated:YES completion:nil];
            }else if(type == TCProfileButtonAllowJoin)
            {
                TCAcceptJoinRequest *acceptReq = [TCAcceptJoinRequest new];
                acceptReq.staffID = _staff.staffID;
                [acceptReq startWithSuccess:^(NSString *message) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
                    weakSelf.staff.update_time = todayString;
                    weakSelf.staff.status = STAFF_STATUS_PASS;
                    [weakSelf updateUI];
                } failure:^(NSString *message) {
                    [MBProgressHUD showError:message toView:nil];
                }];
            }else if(type == TCProfileButtonRejectJoin)
            {
                TCRejectJoinRequest *rejectReq = [TCRejectJoinRequest new];
                rejectReq.staffID = _staff.staffID;
                [rejectReq startWithSuccess:^(NSString *message) {
                    weakSelf.staff.status = STAFF_STATUS_REJECT;
                    [weakSelf updateUI];
                } failure:^(NSString *message) {
                    [MBProgressHUD showError:message toView:nil];
                }];
            }else if(type == TCProfileButtonRemoveStaff)
            {
                NSString *title = @"确定踢出该员工?";
                TCConfirmBlock block = ^(TCConfirmView *view){
                    TCRemoveStaffRequest *removeReq = [TCRemoveStaffRequest new];
                    removeReq.staffID = _staff.staffID;
                    [removeReq startWithSuccess:^(NSString *message) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REMOVE_STAFF object:nil];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        [MMProgressHUD dismissWithSuccess:@"删除成功" title:nil afterDelay:1.32];
                    } failure:^(NSString *message) {
                        [MBProgressHUD showError:message toView:nil];
                    }];
                };
                [TCAlertController presentFromController:weakSelf
                                                   title:title
                                       confirmButtonName:@"踢出"
                                            confirmBlock:block
                                             cancelBlock:nil];
            }else if(type == TCProfileButtonChangeAdmin)
            {
                TCChangeAdminViewController *changeVC = [TCChangeAdminViewController new];
                changeVC.currentStaff = _staff;
                //changeVC.staffArray = self.staffArray;
                //NSLog(@"vc staffs:%@",changeVC.staffArray);
                [self presentViewController:changeVC animated:YES completion:^{
                    
                }];
            }else if(type == TCProfileButtonLeaveCorp)
            {
                NSString *tip = [NSString stringWithFormat:@"确定离开该企业?"];
                TCConfirmBlock confirmBlock = ^(TCConfirmView *view){
                    [MMProgressHUD showWithStatus:@"离开企业中"];
                    TCLeaveCorpRequest *leaveReq = [TCLeaveCorpRequest new];
                    leaveReq.staffID = _staff.staffID;
                    [leaveReq startWithSuccess:^(NSString *message) {
                        [[TCMessageManager shared] clearAllObserver];
                        TCPersonHomeViewController *homeVC = nil;
                        homeVC = [[TCPersonHomeViewController alloc] init];
                        [[TCCurrentCorp shared] reset];
                        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                        [newVCS removeAllObjects];
                        [newVCS addObject:homeVC];
                        [weakSelf.navigationController setViewControllers:newVCS];
                        [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:1.32];
                    } failure:^(NSString *message) {
                        [MMProgressHUD dismissWithError:message afterDelay:1.32];
                    }];
                };
                [TCAlertController presentFromController:weakSelf
                                                   title:tip
                                       confirmButtonName:@"离开"
                                            confirmBlock:confirmBlock
                                             cancelBlock:nil];
                /*
                TCAlertController *alert = [TCAlertController alertControllerWithTitle:tip
                                                                     confirmButtonName:@"离开"
                                                                           cofirmBlock:confirmBlock
                                                                           cancelBlock:nil];
                [weakSelf presentViewController:alert animated:YES completion:nil];
                 */
                
                /*
                NSString *tip = [NSString stringWithFormat:@"确定离开该企业?"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tip
                                                                                         message:nil
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                alertController.view.tintColor = [UIColor grayColor];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [MMProgressHUD showWithStatus:@"离开企业中"];
                    TCLeaveCorpRequest *leaveReq = [TCLeaveCorpRequest new];
                    leaveReq.staffID = _staff.staffID;
                    [leaveReq startWithSuccess:^(NSString *message) {
                        [[TCMessageManager shared] clearAllObserver];
                        TCPersonHomeViewController *homeVC = nil;
                        homeVC = [[TCPersonHomeViewController alloc] init];
                        [[TCCurrentCorp shared] reset];
                        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                        [newVCS removeAllObjects];
                        [newVCS addObject:homeVC];
                        [weakSelf.navigationController setViewControllers:newVCS];
                        [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:1.32];
                    } failure:^(NSString *message) {
                        [MMProgressHUD dismissWithError:message afterDelay:1.32];
                    }];
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:deleteAction];
                [alertController presentationController];
                [self presentViewController:alertController animated:YES completion:nil];
                 */
            }
        };
        return cell;
    }
    TCServerInfoItem *infoItem = [_rowDataArray objectAtIndex:indexPath.row];
    TCStaffProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STAFF_PROFILE_CELL_ID forIndexPath:indexPath];
    [cell setKey:infoItem.key value:infoItem.value];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - extension
- (void) updateUI
{
    [_buttonDataArray removeAllObjects];
    if ([[TCCurrentCorp shared] isAdmin])
    {
        if (_staff.is_admin)
        {
            /*
            TCProfileButtonData *data0 = [TCProfileButtonData new];
            data0.title = @"查看权限";
            data0.color = THEME_TINT_COLOR;
            data0.type = TCProfileButtonViewPermission;
            [_buttonDataArray addObject:data0];
            */
            
            NSInteger uid = [[TCLocalAccount shared] userID];
            if (_staff.uid == uid)
            {
                TCProfileButtonData *data1 = [TCProfileButtonData new];
                data1.title = @"更换管理员";
                data1.color = THEME_TINT_COLOR;
                data1.type = TCProfileButtonChangeAdmin;
                [_buttonDataArray addObject:data1];
            }
        }else if (_staff.status == STAFF_STATUS_PENDING)
        {
            TCProfileButtonData *data1 = [TCProfileButtonData new];
            data1.title = @"允许加入";
            data1.color = THEME_TINT_COLOR;
            data1.type = TCProfileButtonAllowJoin;
            [_buttonDataArray addObject:data1];
            TCProfileButtonData *data2 = [TCProfileButtonData new];
            data2.title = @"拒绝加入";
            data2.color = STATE_ALERT_COLOR;
            data2.type = TCProfileButtonRejectJoin;
            [_buttonDataArray addObject:data2];
        }else if(_staff.status == STAFF_STATUS_REJECT)
        {
            
        }else if(_staff.status == STAFF_STATUS_PASS)
        {
            TCProfileButtonData *data0 = [TCProfileButtonData new];
            data0.title = @"查看权限";
            data0.color = THEME_TINT_COLOR;
            data0.type = TCProfileButtonViewPermission;
            [_buttonDataArray addObject:data0];
            
            TCProfileButtonData *data1 = [TCProfileButtonData new];
            data1.title = @"设置权限";
            data1.color = THEME_TINT_COLOR;
            data1.type = TCProfileButtonSetPermission;
            [_buttonDataArray addObject:data1];
            
            TCProfileButtonData *data2 = [TCProfileButtonData new];
            data2.title = @"踢出企业";
            data2.color = STATE_ALERT_COLOR;
            data2.type = TCProfileButtonRemoveStaff;
            [_buttonDataArray addObject:data2];
        }else if(_staff.status == STAFF_STATUS_FOUNDER)
        {
            TCProfileButtonData *data0 = [TCProfileButtonData new];
            data0.title = @"查看权限";
            data0.color = THEME_TINT_COLOR;
            data0.type = TCProfileButtonViewPermission;
            [_buttonDataArray addObject:data0];
            
            if (!_staff.is_admin)
            {
                TCProfileButtonData *data1 = [TCProfileButtonData new];
                data1.title = @"设置权限";
                data1.color = THEME_TINT_COLOR;
                data1.type = TCProfileButtonSetPermission;
                [_buttonDataArray addObject:data1];
            }
        }
    }else
    {
        if (_staff.status == STAFF_STATUS_PENDING)
        {
            TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
            if ([currentCorp havePermissionForFunc:FUNC_ID_REVIEW_STAFF])
            {
                TCProfileButtonData *data1 = [TCProfileButtonData new];
                data1.title = @"允许加入";
                data1.color = THEME_TINT_COLOR;
                data1.type = TCProfileButtonAllowJoin;
                [_buttonDataArray addObject:data1];
                TCProfileButtonData *data2 = [TCProfileButtonData new];
                data2.title = @"拒绝加入";
                data2.color = STATE_ALERT_COLOR;
                data2.type = TCProfileButtonRejectJoin;
                [_buttonDataArray addObject:data2];
            }
        }else if(_staff.status == STAFF_STATUS_REJECT)
        {
            
        }else if(_staff.status == STAFF_STATUS_PASS ||
                 _staff.status == STAFF_STATUS_FOUNDER)
        {
            if (!_staff.is_admin)
            {
                TCProfileButtonData *data1 = [TCProfileButtonData new];
                data1.title = @"查看权限";
                data1.color = THEME_TINT_COLOR;
                data1.type = TCProfileButtonViewPermission;
                [_buttonDataArray addObject:data1];
            }
            
            NSInteger uid = [[TCLocalAccount shared] userID];
            if (_staff.uid == uid)
            {
                TCProfileButtonData *data2 = [TCProfileButtonData new];
                data2.title = @"离开企业";
                data2.color = STATE_ALERT_COLOR;
                data2.type = TCProfileButtonLeaveCorp;
                [_buttonDataArray addObject:data2];
            }
        }
    }
    
    TCServerInfoItem *statusItem = _rowDataArray.lastObject; //[_rowDataArray objectAtIndex:2];
    if (_staff.status == STAFF_STATUS_REJECT)
    {
        statusItem.value = @"审核不通过";
    }else if(_staff.status == STAFF_STATUS_PENDING)
    {
        statusItem.value = @"待审核";
    }else if(_staff.status == STAFF_STATUS_PASS)
    {
        statusItem.value = @"审核通过";
    }else if(_staff.status == STAFF_STATUS_FOUNDER)
    {
        statusItem.value = @"创建人";
    }else if(_staff.status == STAFF_STATUS_WAITING)
    {
        statusItem.value = @"待加入";
    }
    
    if (_rowDataArray.count >= 2)
    {
        NSInteger itemIndex = _rowDataArray.count - 2;
        TCServerInfoItem *joinTimeItem = [_rowDataArray objectAtIndex:itemIndex];
        NSString *updateTime = _staff.update_time;
        if (_staff.status == STAFF_STATUS_REJECT ||
            _staff.status == STAFF_STATUS_PENDING)
        {
            joinTimeItem.value = @"";
        }else
        {
            if (updateTime && updateTime.length > 11)
            {
                NSRange dateRange = NSMakeRange(0, 10);
                joinTimeItem.value = [updateTime substringWithRange:dateRange];
            }else
            {
                joinTimeItem.value = updateTime;
            }
        }
    }
    [self.tableView reloadData];
    [self.buttonTableView reloadData];
}

- (void) reloadUserPermission
{
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCUserPermissionRequest *req = [TCUserPermissionRequest new];
    req.corpID = [[TCCurrentCorp shared] cid];
    req.userID = _staff.uid;
    [req startWithSuccess:^(TCTemplate *tmpl) {
        weakSelf.userTemplate = tmpl;
        NSLog(@"get servers:%@",tmpl.access_servers);
        [weakSelf stopLoading];
    } failure:^(NSString *message,NSInteger errorCode) {
        if (errorCode == 10003)
        {
            [MBProgressHUD showError:@"该员工已离开公司" toView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [weakSelf stopLoading];
    }];
}

#pragma mark - TCCurrentCorpDelegate
- (void) corpModified:(TCCurrentCorp*)corp
{
    [self updateUI];
}

#pragma mark - TCDataSyncDelegate
- (void) dataSync:(TCDataSync*)sync permissionChanged:(NSInteger)changed
{
    [self updateUI];
    if (_staff.status == STAFF_STATUS_PASS ||
        _staff.status == STAFF_STATUS_FOUNDER )
    {
        [self reloadUserPermission];
    }
}
@end
