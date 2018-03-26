//
//  TCServerUsage2Cell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerUsage2Cell.h"
#import "TCServerUsage+CoreDataClass.h"

@interface TCServerUsage2Cell()

@end

@implementation TCServerUsage2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setUsage:(TCServerUsage*)usage
{
    [super setUsage:usage];
    NSString *cpuDesc = [NSString stringWithFormat:@"%g%%",usage.cpuUsageRate.doubleValue];
    self.cpuLabel.text = cpuDesc;
    NSString *memoryDesc = [NSString stringWithFormat:@"%g%%",usage.memUsageRate.doubleValue];
    self.memoryLabel.text = memoryDesc;
    NSString *diskDesc = [NSString stringWithFormat:@"%g%%",usage.diskUsageRate.doubleValue];
    self.diskLabel.text = diskDesc;
    self.networkLabel.text = usage.networkUsage;
    
    CGFloat cpuRate = usage.cpuUsageRate.floatValue;
    CGFloat memoryRate = usage.memUsageRate.floatValue;
    CGFloat diskIORate = usage.diskIO.floatValue;
    CGFloat diskUsageRate = usage.diskUsageRate.floatValue;
    NSString *cpuStr = [NSString stringWithFormat:@"CPU使用率  %g%%",cpuRate];
    NSString *memoryStr = [NSString stringWithFormat:@"内存使用率  %g%%",memoryRate];
    NSString *diskStr = [NSString stringWithFormat:@"磁盘占用率  %g%%",diskUsageRate];
    NSString *diskIOStr = [NSString stringWithFormat:@"磁盘利用率 %g%%",diskIORate];
    NSString *netIOStr = [NSString stringWithFormat:@"网络I %@  网络O %@",usage.netUpload, usage.netDownload];
    self.row1Label.text = cpuStr;
    self.row2Label.text = memoryStr;
    self.row3Label.text = diskIOStr;
    self.row4Label.text = diskStr;
    self.row5Label.text = netIOStr;
}
@end
