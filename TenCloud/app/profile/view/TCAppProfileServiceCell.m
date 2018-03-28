//
//  TCAppProfileServiceCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAppProfileServiceCell.h"
#import "TCService+CoreDataClass.h"
#import "TCIconStatusLabel.h"
#import "NSString+Extension.h"

@interface TCAppProfileServiceCell ()
@property (nonatomic, strong)   TCService           *service;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIView      *bgView;
@property (nonatomic, weak) IBOutlet    TCIconStatusLabel   *statusLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *typeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *clusterIPLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *outerIPLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *loadBalanceLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *portLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *createTimeLabel;
- (void) updateUI;
@end

@implementation TCAppProfileServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bgView.layer.cornerRadius = TCSCALE(2.0);
    
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

- (void) setService:(TCService*)service
{
    _nameLabel.text = service.name;
    _typeLabel.text = @"ClusterIP";///service.
    _clusterIPLabel.text = service.clusterIP;
    _outerIPLabel.text = service.outerIP;
    _loadBalanceLabel.text = service.loadBalancing;
    _portLabel.text = service.port;
    _createTimeLabel.text = [NSString dateTimeStringFromTimeInterval:service.createTime];
}

- (void) updateUI
{
    if (self.highlighted)
    {
        self.bgView.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
    }else
    {
        self.bgView.backgroundColor = TABLE_CELL_BG_COLOR;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

@end
