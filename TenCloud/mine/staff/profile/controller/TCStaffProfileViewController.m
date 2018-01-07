//
//  TCStaffProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/7.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCStaffProfileViewController.h"
//#import "TCServerConfigTableViewCell.h"
#import "TCStaffProfileTableViewCell.h"
#import "TCServerInfoItem.h"
#import "TCStaff+CoreDataClass.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define STAFF_PROFILE_CELL_ID       @"STAFF_PROFILE_CELL_ID"

@interface TCStaffProfileViewController ()
@property (nonatomic, strong)   TCStaff         *staff;
@property (nonatomic, strong)   NSMutableArray  *rowDataArray;
@property (nonatomic, weak)     IBOutlet    UITableView     *tableView;
@property (nonatomic, weak)     IBOutlet    UIImageView     *avatarView;
@property (nonatomic, weak)     IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak)     IBOutlet    UILabel         *phoneLabel;
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
    
    _rowDataArray = [NSMutableArray new];
    UINib *cellNib = [UINib nibWithNibName:@"TCStaffProfileTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:STAFF_PROFILE_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    
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
    return _rowDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
