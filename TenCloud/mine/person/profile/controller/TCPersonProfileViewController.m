//
//  TCPersonProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPersonProfileViewController.h"
#import "TCEditTextTableViewCell.h"
#import "TCEditAvatarTableViewCell.h"
#import "TCEditGenderTableViewCell.h"
#import "TCEditDateTableViewCell.h"
#define PROFILE_CELL_EDIT_TEXT      @"PROFILE_CELL_EDIT_TEXT"
#define PROFILE_CELL_EDIT_AVATAR    @"PROFILE_CELL_EDIT_AVATAR"
#define PROFILE_CELL_EDIT_GENDAR    @"PROFILE_CELL_EDIT_GENDAR"
#define PROFILE_CELL_EDIT_DATE      @"PROFILE_CELL_EDIT_DATE"

@interface TCPersonProfileViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *cellItemArray;
@end

@implementation TCPersonProfileViewController

- (instancetype) init
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
    self.title = @"个人资料";
    
    TCLocalAccount *account = [TCLocalAccount shared];
    _cellItemArray = [NSMutableArray new];
    TCEditCellData *data1 = [TCEditCellData new];
    data1.title = @"头像";
    data1.initialValue = account.avatar;
    data1.type = TCCellTypeEditAvatar;
    [_cellItemArray addObject:data1];
    
    TCEditCellData *data2 = [TCEditCellData new];
    data2.title = @"姓名";
    data2.editPageTitle = @"修改姓名";
    data2.keyName = @"name";
    data2.initialValue = account.name;
    data2.type = TCCellTypeEditText;
    [_cellItemArray addObject:data2];
    
    TCEditCellData *data4 = [TCEditCellData new];
    data4.title = @"邮箱";
    data4.editPageTitle = @"修改邮箱";
    data4.keyName = @"email";
    data4.initialValue = account.email;
    data4.type = TCCellTypeEditText;
    [_cellItemArray addObject:data4];
    
    TCEditCellData *data5 = [TCEditCellData new];
    data5.title = @"性别";
    data5.keyName = @"gender";
    data5.initialValue = @(account.gender);
    data5.type = TCCellTypeEditGender;
    [_cellItemArray addObject:data5];
    
    TCEditCellData *data6 = [TCEditCellData new];
    data6.title = @"生日";
    data6.keyName = @"birthday";
    data6.initialValue = @(account.birthday);
    data6.type = TCCellTypeEditDate;
    [_cellItemArray addObject:data6];
    
    UINib *textCellNib = [UINib nibWithNibName:@"TCEditTextTableViewCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_TEXT];
    UINib *avatarCellNib = [UINib nibWithNibName:@"TCEditAvatarTableViewCell" bundle:nil];
    [self.tableView registerNib:avatarCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_AVATAR];
    UINib *genderCellNib = [UINib nibWithNibName:@"TCEditGenderTableViewCell" bundle:nil];
    [self.tableView registerNib:genderCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_GENDAR];
    UINib *dateCellNib = [UINib nibWithNibName:@"TCEditDateTableViewCell" bundle:nil];
    [self.tableView registerNib:dateCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_DATE];
    self.tableView.tableFooterView = [UIView new];
    
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
    return _cellItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCEditCellData *data = [_cellItemArray objectAtIndex:indexPath.row];
    if (data.type == TCCellTypeEditAvatar)
    {
        TCEditAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFILE_CELL_EDIT_AVATAR forIndexPath:indexPath];
        cell.fatherViewController = self;
        cell.data = data;
        cell.valueChangedBlock = ^(TCBasicTableViewCell *cell, NSInteger selectedIndex, id newValue) {
            
        };
        return cell;
    }else if(data.type == TCCellTypeEditGender)
    {
        TCEditGenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFILE_CELL_EDIT_GENDAR forIndexPath:indexPath];
        cell.fatherViewController = self;
        cell.data = data;
        return cell;
    }else if(data.type == TCCellTypeEditDate)
    {
        TCEditDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFILE_CELL_EDIT_DATE
                                                                        forIndexPath:indexPath];
        cell.fatherViewController = self;
        cell.data = data;
        return cell;
    }
    
    TCEditTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFILE_CELL_EDIT_TEXT forIndexPath:indexPath];
    cell.fatherViewController = self;
    cell.data = data;
    cell.valueChangedBlock = ^(TCBasicTableViewCell *cell, NSInteger selectedIndex, id newValue) {
        
    };
    return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
