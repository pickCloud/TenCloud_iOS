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
@property (nonatomic, weak) IBOutlet    UIImageView *iconView;
@property (nonatomic, weak) IBOutlet    UIView      *bg2View;
@property (nonatomic, weak) IBOutlet    TCProgressView  *cpuProgressView;
@property (nonatomic, weak) IBOutlet    UILabel         *cpuProgressLabel;
@property (nonatomic, weak) IBOutlet    TCProgressView  *diskProgressView;
@property (nonatomic, weak) IBOutlet    UILabel         *diskProgressLabel;
@property (nonatomic, weak) IBOutlet    TCProgressView  *memoryProgressView;
@property (nonatomic, weak) IBOutlet    UILabel         *memoryProgressLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *networkSpeedLabel;
- (void) updateUI;
@end

@implementation TCServerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.02];
    self.selectedBackgroundView = selectedBgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"set selected:%d",selected);
    // Configure the view for the selected state
    [self updateUI];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateUI];
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
    
}

- (void) updateUI
{
    if (self.selected)
    {
        self.bg2View.backgroundColor = [UIColor redColor]; //TABLE_CELL_BG_COLOR;
    }else
    {
        self.bg2View.backgroundColor = TABLE_CELL_BG_COLOR;
    }
}
@end
