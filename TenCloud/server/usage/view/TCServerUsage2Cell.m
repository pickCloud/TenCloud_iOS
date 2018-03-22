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
}
@end
