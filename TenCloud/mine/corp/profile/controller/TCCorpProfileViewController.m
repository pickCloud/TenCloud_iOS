//
//  TCCorpProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCorpProfileViewController.h"
#import "TCCorp+CoreDataClass.h"
#import "TCTextTableViewCell.h"
#import "TCEditTextTableViewCell.h"
#import "TCEditAvatarTableViewCell.h"
#import "TCEditGenderTableViewCell.h"
#import "TCEditDateTableViewCell.h"
#import "TCCertificateTableViewCell.h"
#define PROFILE_CELL_EDIT_TEXT      @"PROFILE_CELL_EDIT_TEXT"
#define PROFILE_CELL_EDIT_AVATAR    @"PROFILE_CELL_EDIT_AVATAR"
#define PROFILE_CELL_EDIT_GENDAR    @"PROFILE_CELL_EDIT_GENDAR"
#define PROFILE_CELL_EDIT_DATE      @"PROFILE_CELL_EDIT_DATE"
#define PROFILE_CELL_TEXT           @"PROFILE_CELL_TEXT"
#define PROFILE_CELL_CERTIFICATE    @"PROFILE_CELL_CERTIFICATE"

@interface TCCorpProfileViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *cellItemArray;
@property (nonatomic, strong)   TCCorp                  *corp;
@end

@implementation TCCorpProfileViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype) initWithCorp:(TCCorp*)corp
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        _corp = corp;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业资料";
    
    //TCLocalAccount *account = [TCLocalAccount shared];
    BOOL editPermission = [[TCCurrentCorp shared] havePermissionForFunc:FUNC_ID_MODIFY_CORP];
    BOOL editable = [[TCCurrentCorp shared] isAdmin] || editPermission;
    NSLog(@"editable:%ld isAdmin:%ld",editable, [[TCCurrentCorp shared] isAdmin]);
    
    _cellItemArray = [NSMutableArray new];
    TCCellData *data1 = [TCCellData new];
    data1.title = @"LOGO";
    data1.initialValue = _corp.image_url;
    data1.type = TCCellTypeEditAvatar;
    data1.hideDetailView = YES;
    data1.apiType = TCApiTypeUpdateCorp;
    data1.cid = _corp.cid;
    data1.editable = editable;
    [_cellItemArray addObject:data1];
    
    TCCellData *data2 = [TCCellData new];
    data2.title = @"企业名称";
    data2.editPageTitle = @"修改企业名称";
    data2.keyName = @"name";
    data2.initialValue = _corp.name;
    data2.type = TCCellTypeEditText;
    data2.apiType = TCApiTypeUpdateCorp;
    data2.cid = _corp.cid;
    data2.editable = editable;
    [_cellItemArray addObject:data2];
    
    TCCellData *data4 = [TCCellData new];
    data4.title = @"联系人";
    data4.editPageTitle = @"修改联系人";
    data4.keyName = @"contact";
    data4.initialValue = _corp.contact;
    data4.type = TCCellTypeEditText;
    data4.apiType = TCApiTypeUpdateCorp;
    data4.cid = _corp.cid;
    data4.editable = editable;
    [_cellItemArray addObject:data4];
    
    TCCellData *data5 = [TCCellData new];
    data5.title = @"联系方式";
    data5.editPageTitle = @"修改联系方式";
    data5.keyName = @"mobile";
    data5.initialValue = _corp.mobile;
    data5.type = TCCellTypeEditText;
    data5.apiType = TCApiTypeUpdateCorp;
    data5.cid = _corp.cid;
    data5.editable = editable;
    [_cellItemArray addObject:data5];
    
    TCCellData *data6 = [TCCellData new];
    data6.title = @"创建时间";
    NSString *createTime = _corp.create_time;
    if (createTime && createTime.length > 11)
    {
        NSRange dateRange = NSMakeRange(0, 10);
        createTime = [createTime substringWithRange:dateRange];
    }
    data6.initialValue = createTime;
    data6.type = TCCellTypeText;
    data6.hideDetailView = YES;
    data6.editable = editable;
    [_cellItemArray addObject:data6];
    
    TCCellData *data7 = [TCCellData new];
    data7.title = @"是否认证";
    data7.initialValue = @"未认证";
    data7.type = TCCellTypeCertificate;
    data7.editable = editable;
    [_cellItemArray addObject:data7];
    
    /*
    TCCellData *data5 = [TCCellData new];
    data5.title = @"性别";
    data5.keyName = @"gender";
    data5.initialValue = @(account.gender);
    data5.type = TCCellTypeEditGender;
    [_cellItemArray addObject:data5];
    
    TCCellData *data6 = [TCCellData new];
    data6.title = @"生日";
    data6.keyName = @"birthday";
    data6.initialValue = @(account.birthday);
    data6.type = TCCellTypeEditDate;
    [_cellItemArray addObject:data6];
     */
    
    UINib *editTextCellNib = [UINib nibWithNibName:@"TCEditTextTableViewCell" bundle:nil];
    [self.tableView registerNib:editTextCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_TEXT];
    UINib *avatarCellNib = [UINib nibWithNibName:@"TCEditAvatarTableViewCell" bundle:nil];
    [self.tableView registerNib:avatarCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_AVATAR];
    UINib *genderCellNib = [UINib nibWithNibName:@"TCEditGenderTableViewCell" bundle:nil];
    [self.tableView registerNib:genderCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_GENDAR];
    UINib *dateCellNib = [UINib nibWithNibName:@"TCEditDateTableViewCell" bundle:nil];
    [self.tableView registerNib:dateCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_DATE];
    UINib *textCellNib = [UINib nibWithNibName:@"TCTextTableViewCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:PROFILE_CELL_TEXT];
    UINib *certificateCellNib = [UINib nibWithNibName:@"TCCertificateTableViewCell" bundle:nil];
    [self.tableView registerNib:certificateCellNib forCellReuseIdentifier:PROFILE_CELL_CERTIFICATE];
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
    TCCellData *data = [_cellItemArray objectAtIndex:indexPath.row];
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
    }else if(data.type == TCCellTypeText)
    {
        TCTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFILE_CELL_TEXT forIndexPath:indexPath];
        cell.fatherViewController = self;
        cell.data = data;
        return cell;
    }else if(data.type == TCCellTypeCertificate)
    {
        TCCertificateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFILE_CELL_CERTIFICATE forIndexPath:indexPath];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
