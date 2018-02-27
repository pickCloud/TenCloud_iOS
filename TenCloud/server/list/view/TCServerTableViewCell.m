//
//  TCServerTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerTableViewCell.h"
#import "TCServer+CoreDataClass.h"
#import "TCServerNet+CoreDataClass.h"
#import "TCServerCPU+CoreDataClass.h"
#import "TCServerDisk+CoreDataClass.h"
#import "TCServerMemory+CoreDataClass.h"
#import "TCProgressView.h"

@interface TCServerTableViewCell ()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *ipLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *statusLabel;
@property (nonatomic, weak) IBOutlet    UIView      *statusBackgroundView;
@property (nonatomic, weak) IBOutlet    UIImageView *iconView;
@property (nonatomic, weak) IBOutlet    UIView      *bg2View;
@property (nonatomic, weak) IBOutlet    TCProgressView  *cpuProgressView;
@property (nonatomic, weak) IBOutlet    UILabel         *cpuProgressLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *cpuLabel;
@property (nonatomic, weak) IBOutlet    TCProgressView  *diskProgressView;
@property (nonatomic, weak) IBOutlet    UILabel         *diskProgressLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *diskLabel;
@property (nonatomic, weak) IBOutlet    TCProgressView  *memoryProgressView;
@property (nonatomic, weak) IBOutlet    UILabel         *memoryProgressLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *memoryLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *networkSpeedLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *networkLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *speedLabel;
- (void) updateUI;
@end

@implementation TCServerTableViewCell

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
    self.cpuProgressLabel.font = TCFont(10.0);
    self.diskProgressLabel.font = TCFont(10.0);
    self.memoryProgressLabel.font = TCFont(10.0);
    self.networkSpeedLabel.font = TCFont(10.0);
    self.statusLabel.font = TCFont(9.0);
    self.cpuLabel.font = TCFont(10);
    self.memoryLabel.font = TCFont(10);
    self.diskLabel.font = TCFont(10);
    self.networkLabel.font = TCFont(10);
    self.speedLabel.font = TCFont(9);
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

- (void) setServer:(TCServer*)server
{
    self.nameLabel.text = server.name;
    self.ipLabel.text = server.public_ip;
    UIImage *iconImage = nil;
    if ([server.provider isEqualToString:SERVER_PROVIDER_ALIYUN])
    {
        iconImage = [UIImage imageNamed:@"server_type_aliyun"];
    }else if([server.provider isEqualToString:SERVER_PROVIDER_AMAZON])
    {
        iconImage = [UIImage imageNamed:@"server_type_amazon"];
    }else if([server.provider isEqualToString:SERVER_PROVIDER_MICROS])
    {
        iconImage = [UIImage imageNamed:@"server_type_microyun"];
    }else
    {
        iconImage = [UIImage imageNamed:@"server_type_tencentyun"];
    }
    [_iconView setImage:iconImage];
    CGFloat cpuProgress = server.cpu_content.percent.floatValue;
    _cpuProgressView.progress = cpuProgress/100.0;
    NSString *cpuProgressStr = [NSString stringWithFormat:@"%.02f%%",cpuProgress];
    _cpuProgressLabel.text = cpuProgressStr;
    
    CGFloat diskProgress = server.disk_content.percent.floatValue;
    _diskProgressView.progress = diskProgress / 100.0;
    NSString *diskProgressStr = [NSString stringWithFormat:@"%.02f%%",diskProgress];
    _diskProgressLabel.text = diskProgressStr;
    
    CGFloat memoryProgress = server.memory_content.percent.floatValue;
    _memoryProgressView.progress = memoryProgress / 100.0;
    NSString *memoryProgressStr = [NSString stringWithFormat:@"%.02f%%",memoryProgress];
    _memoryProgressLabel.text = memoryProgressStr;
    
    NSInteger input = server.net_content.input;
    NSInteger output = server.net_content.output;
    NSString *networkSpeedStr = [NSString stringWithFormat:@"%ld/%ld",input,output];
    _networkSpeedLabel.text = networkSpeedStr;
    
    NSString *statusStr = server.machine_status;
    _statusLabel.text = server.machine_status;
    if (statusStr && statusStr.length > 0)
    {
        if ([statusStr containsString:@"停止"])
        {
            _statusLabel.textColor = STATE_ALERT_COLOR;
            _statusBackgroundView.backgroundColor = STATE_ALERT_BG_COLOR;
        }else if([statusStr containsString:@"异常"])
        {
            _statusLabel.textColor = STATE_ERROR_COLOR;
            _statusBackgroundView.backgroundColor = STATE_ERROR_BG_COLOR;
        }else
        {
            _statusLabel.textColor = STATE_NORMAL_COLOR;
            _statusBackgroundView.backgroundColor = STATE_NORMAL_BG_COLOR;
        }
    }
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
