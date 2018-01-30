//
//  TCMonitorHistoryTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMonitorHistoryTableViewCell.h"
#import "TCServer+CoreDataClass.h"
#import "TCServerNet+CoreDataClass.h"
#import "TCServerCPU+CoreDataClass.h"
#import "TCServerDisk+CoreDataClass.h"
#import "TCServerMemory+CoreDataClass.h"
#import "TCPerformanceItem+CoreDataClass.h"
#import "TCProgressView.h"

@interface TCMonitorHistoryTableViewCell ()
@property (nonatomic, weak) IBOutlet    UILabel       *timeLabel;
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

@implementation TCMonitorHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bg2View.layer.cornerRadius = TCSCALE(2.0);
    
    self.cpuProgressLabel.font = TCFont(10.0);
    self.diskProgressLabel.font = TCFont(10.0);
    self.memoryProgressLabel.font = TCFont(10.0);
    self.networkSpeedLabel.font = TCFont(10.0);
    self.cpuLabel.font = TCFont(10);
    self.memoryLabel.font = TCFont(10);
    self.diskLabel.font = TCFont(10);
    self.networkLabel.font = TCFont(10);
    self.speedLabel.font = TCFont(9);
    self.timeLabel.font = TCFont(13);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"set selected:%d",selected);
    // Configure the view for the selected state
    [self updateUI];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    NSLog(@"highlighted:%d",highlighted);
    [self updateUI];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

- (void) setPerformance:(TCPerformanceItem*)performance
{
    NSInteger createTimeInt = performance.created_time;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTimeInt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *createDateStr = [dateFormatter stringFromDate:date];
    _timeLabel.text = createDateStr;
    
    CGFloat cpuProgress = performance.cpu.percent.floatValue;
    //performance.cpu_content.percent.floatValue;
    _cpuProgressView.progress = cpuProgress/100.0;
    NSString *cpuProgressStr = [NSString stringWithFormat:@"%.02f%%",cpuProgress];
    _cpuProgressLabel.text = cpuProgressStr;
    
    CGFloat diskProgress = performance.disk.percent.floatValue;
    //server.disk_content.percent.floatValue;
    _diskProgressView.progress = diskProgress / 100.0;
    NSString *diskProgressStr = [NSString stringWithFormat:@"%.02f%%",diskProgress];
    _diskProgressLabel.text = diskProgressStr;
    
    CGFloat memoryProgress = performance.memory.percent.floatValue;
    //server.memory_content.percent.floatValue;
    _memoryProgressView.progress = memoryProgress / 100.0;
    NSString *memoryProgressStr = [NSString stringWithFormat:@"%.02f%%",memoryProgress];
    _memoryProgressLabel.text = memoryProgressStr;
    
    NSInteger input = performance.net.input;
    //server.net_content.input;
    NSInteger output = performance.net.output;
    //server.net_content.output;
    NSString *networkSpeedStr = [NSString stringWithFormat:@"%ld/%ld",input,output];
    _networkSpeedLabel.text = networkSpeedStr;
    
}

- (void) updateUI
{
    if (self.highlighted)
    {
        self.bg2View.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
        NSLog(@"变红");
    }else
    {
        self.bg2View.backgroundColor = TABLE_CELL_BG_COLOR;
        NSLog(@"不变红");
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}
@end
