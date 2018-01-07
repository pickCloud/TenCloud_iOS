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


@interface TCStaffTableViewCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *phoneLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *statusLabel;
@property (nonatomic, weak) IBOutlet    UIImageView *avatarView;
@end

@implementation TCStaffTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.05];
    self.selectedBackgroundView = selectedBgView;
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
    }else if(staff.status == 2)
    {
        _statusLabel.text = @"创始人";
        _statusLabel.textColor = THEME_TINT_COLOR;
    }else
    {
        _statusLabel.text = @"审核通过";
        _statusLabel.textColor = THEME_TEXT_COLOR;
    }
}

@end
