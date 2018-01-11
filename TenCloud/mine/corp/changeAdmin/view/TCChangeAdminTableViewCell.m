//
//  TCChangeAdminTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2018/1/11.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCChangeAdminTableViewCell.h"
#import "TCStaff+CoreDataClass.h"
#import "NSString+Extension.h"
@interface TCChangeAdminTableViewCell ()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *phoneLabel;
@property (nonatomic, weak) IBOutlet    UIImageView *selectedView;
@end

@implementation TCChangeAdminTableViewCell

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

- (void)setStaff:(TCStaff*)staff
{
    _nameLabel.text = staff.name;
    if (staff.mobile.length >= 11)
    {
        _phoneLabel.text = [NSString hiddenPhoneNumStr:staff.mobile];
    }else
    {
        _phoneLabel.text = staff.mobile;
    }
    
    if (staff.is_admin)
    {
        _selectedView.hidden = NO;
    }else
    {
        _selectedView.hidden = YES;
    }
}
@end
