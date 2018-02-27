//
//  TCServerPermTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerPermTableViewCell.h"
#import "TCPermissionNode+CoreDataClass.h"

@interface TCServerPermTableViewCell ()
@property (nonatomic, weak) IBOutlet    UILabel     *areaLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *ipLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *statusLabel;
@property (nonatomic, weak) IBOutlet    UIView      *statusBackgroundView;
@property (nonatomic, weak) IBOutlet    UIImageView *iconView;
@property (nonatomic, weak) IBOutlet    UIView      *bg2View;

- (void) updateUI;
@end

@implementation TCServerPermTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bg2View.layer.cornerRadius = TCSCALE(2.0);
    self.nameLabel.font = TCFont(14);
    self.ipLabel.font = TCFont(9.0);
    self.statusLabel.font = TCFont(9.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self updateUI];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateUI];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    //[self updateUI];
}

- (void) setNode:(TCPermissionNode *)node
{
    [super setNode:node];
    self.nameLabel.text = node.name;
    self.areaLabel.text = node.region_name;
    self.ipLabel.text = node.public_ip;
    
    UIImage *iconImage = nil;
    if ([node.provider isEqualToString:SERVER_PROVIDER_ALIYUN])
    {
        iconImage = [UIImage imageNamed:@"server_type_aliyun"];
    }else if([node.provider isEqualToString:SERVER_PROVIDER_AMAZON])
    {
        iconImage = [UIImage imageNamed:@"server_type_amazon"];
    }else if([node.provider isEqualToString:SERVER_PROVIDER_MICROS])
    {
        iconImage = [UIImage imageNamed:@"server_type_microyun"];
    }else
    {
        iconImage = [UIImage imageNamed:@"server_type_tencentyun"];
    }
    [_iconView setImage:iconImage];
}

- (void) updateUI
{
    if (self.highlighted)
    {
        self.bg2View.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
    }else
    {
        self.bg2View.backgroundColor = TABLE_CELL_BG_COLOR;
    }
}

- (void) layoutSubviews
{
    CGSize statusSize = self.statusBackgroundView.bounds.size;
    self.statusBackgroundView.layer.cornerRadius = statusSize.height / 2.0;
    [super layoutSubviews];
}
@end
