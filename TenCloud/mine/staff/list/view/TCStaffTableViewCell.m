//
//  TCStaffTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCStaffTableViewCell.h"
#import "TCStaff+CoreDataClass.h"
#import "NSString+Extension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TCStaffLabel.h"


@interface TCStaffTableViewCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *phoneLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *statusLabel;
@property (nonatomic, weak) IBOutlet    UIImageView *avatarView;
@property (nonatomic, weak) IBOutlet    TCStaffLabel    *adminLabel;


@end

@implementation TCStaffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.05];
    self.selectedBackgroundView = selectedBgView;
    [_adminLabel setType:TCStaffTypeAdmin];
    _adminLabel.font = TCFont(9.09);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setStaff:(TCStaff *)staff
{
    _nameLabel.text = staff.name;
    NSString *hiddenPhoneStr = [NSString hiddenPhoneNumStr:staff.mobile];
    _phoneLabel.text = hiddenPhoneStr;
    NSURL *avatarURL = [NSURL URLWithString:staff.image_url];
    UIImage *defaultAvatar = [UIImage imageNamed:@"default_avatar"];
    [_avatarView sd_setImageWithURL:avatarURL placeholderImage:defaultAvatar];
    if (staff.status == STAFF_STATUS_REJECT)
    {
        _statusLabel.text = @"审核不通过";
        _statusLabel.textColor = STATE_ALERT_COLOR;
    }else if(staff.status == STAFF_STATUS_PENDING)
    {
        _statusLabel.text = @"待审核";
        _statusLabel.textColor = THEME_TINT_COLOR;
    }else if(staff.status == STAFF_STATUS_FOUNDER)
    {
        _statusLabel.text = @"创建人";
        _statusLabel.textColor = THEME_TINT_COLOR;
    }else if(staff.status == STAFF_STATUS_PASS)
    {
        _statusLabel.text = @"审核通过";
        _statusLabel.textColor = THEME_TEXT_COLOR;
    }else if(staff.status == STAFF_STATUS_WAITING)
    {
        _statusLabel.text = @"待加入";
        _statusLabel.textColor = THEME_TEXT_COLOR;
    }
    if (staff.is_admin)
    {
        [_adminLabel setHidden:NO];
    }else
    {
        [_adminLabel setHidden:YES];
    }
}


@end
