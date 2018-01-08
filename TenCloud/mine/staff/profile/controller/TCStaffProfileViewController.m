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

#define STAFF_PROFILE_CELL_ID       @"STAFF_PROFILE_CELL_ID"
#define STAFF_BUTTON_CELL_ID        @"STAFF_BUTTON_CELL_ID"

@interface TCStaffProfileViewController ()
@property (nonatomic, strong)   TCStaff         *staff;
@property (nonatomic, strong)   TCTemplate      *userTemplate;
@property (nonatomic, strong)   NSMutableArray  *rowDataArray;
@property (nonatomic, strong)   NSMutableArray  *buttonDataArray;
@property (nonatomic, weak)     IBOutlet    UITableView     *tableView;
@property (nonatomic, weak)     IBOutlet    UIImageView     *avatarView;
@property (nonatomic, weak)     IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak)     IBOutlet    UILabel         *phoneLabel;
@property (nonatomic, weak)     IBOutlet    UITableView     *buttonTableView;
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
    if ([[TCCurrentCorp shared] isAdmin])
    {
        if (_staff.status == STAFF_STATUS_PENDING)
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
            
        }else
        {
            TCProfileButtonData *data1 = [TCProfileButtonData new];
            data1.title = @"设置权限";
            data1.color = THEME_TINT_COLOR;
            data1.type = TCProfileButtonSetPermission;
            [_buttonDataArray addObject:data1];
            
            TCProfileButtonData *data2 = [TCProfileButtonData new];
            data2.title = @"解除关系";
            data2.color = STATE_ALERT_COLOR;
            data2.type = TCProfileButtonRemove;
            [_buttonDataArray addObject:data2];
        }
    }else
    {
        if (_staff.status == STAFF_STATUS_PENDING)
        {
            
        }else if(_staff.status == STAFF_STATUS_REJECT)
        {
            
        }else
        {
            TCProfileButtonData *data1 = [TCProfileButtonData new];
            data1.title = @"查看权限";
            data1.color = THEME_TINT_COLOR;
            data1.type = TCProfileButtonViewPermission;
            [_buttonDataArray addObject:data1];
        }
    }
    TCProfileButtonData *data11 = [TCProfileButtonData new];
    data11.title = @"设置权限";
    data11.color = THEME_TINT_COLOR;
    data11.type = TCProfileButtonSetPermission;
    [_buttonDataArray addObject:data11];
    

    
    UINib *buttonCellNib = [UINib nibWithNibName:@"TCButtonTableViewCell" bundle:nil];
    [_buttonTableView registerNib:buttonCellNib forCellReuseIdentifier:STAFF_BUTTON_CELL_ID];
    
    _rowDataArray = [NSMutableArray new];
    UINib *cellNib = [UINib nibWithNibName:@"TCStaffProfileTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:STAFF_PROFILE_CELL_ID];
    _tableView.tableFooterView = _buttonTableView;
    
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
    if (updateTime && updateTime.length > 11)
    {
        NSRange dateRange = NSMakeRange(0, 10);
        updateTime = [updateTime substringWithRange:dateRange];
    }
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
    
    _nameLabel.text = _staff.name;
    NSURL *avatarURL = [NSURL URLWithString:_staff.image_url];
    UIImage *defaultAvatar = [UIImage imageNamed:@"default_avatar"];
    [_avatarView sd_setImageWithURL:avatarURL placeholderImage:defaultAvatar];
    _phoneLabel.text = _staff.mobile;
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCUserPermissionRequest *req = [TCUserPermissionRequest new];
    req.corpID = [[TCCurrentCorp shared] cid];
    req.userID = _staff.uid;
    [req startWithSuccess:^(TCTemplate *tmpl) {
        weakSelf.userTemplate = tmpl;
        [weakSelf stopLoading];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
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
                [[TCEditingPermission shared] reset];
                [[TCEditingPermission shared] setTemplate:_userTemplate];
                [[TCEditingPermission shared] readyForPreview];
                TCPermissionViewController *perVC = [TCPermissionViewController new];
                perVC.userID = _staff.uid;
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
                NSLog(@"允许加入");
            }else if(type == TCProfileButtonRejectJoin)
            {
                NSLog(@"拒绝加入");
            }else
            {
                NSLog(@"其他");
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

@end
