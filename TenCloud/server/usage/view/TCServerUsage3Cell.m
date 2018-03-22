//
//  TCServerUsage3Cell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerUsage3Cell.h"
#import "TCServerUsage+CoreDataClass.h"

@interface TCServerUsage3Cell()
//@property (nonatomic, strong)   CAGradientLayer     *gradientLayer;
@end

@implementation TCServerUsage3Cell

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
}
@end
