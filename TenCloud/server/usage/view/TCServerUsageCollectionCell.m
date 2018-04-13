//
//  TCServerUsageCollectionCell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerUsageCollectionCell.h"
#import "TCServerUsage+CoreDataClass.h"
#import "TCConfiguration.h"
#import "TCServerThreshold+CoreDataClass.h"

@interface TCServerUsageCollectionCell()
@property (nonatomic, strong)   CAGradientLayer     *gradientLayer;
@end

@implementation TCServerUsageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:_gradientLayer atIndex:0];
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void) setUsage:(TCServerUsage*)usage
{
    NSLog(@"set usage ");
    _usage = usage;
    _nameLabel.text = usage.name;
    
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    //_gradientLayer.startPoint = CGPointMake(0.5, 0);
    //_gradientLayer.endPoint = CGPointMake(0.5, 1);
    UIColor *color1 = nil;
    UIColor *color2 = nil;
    if (usage.colorType == TCServerUsageIdle)
    {
        color1 = [UIColor colorWithRed:86/255.0 green:98/255.0 blue:120/255.0 alpha:1.0];
        color2 = [UIColor colorWithRed:38/255.0 green:42/255.0 blue:53/255.0 alpha:1.0];
    }else if(usage.colorType == TCServerUsageSafe)
    {
        color1 = [UIColor colorWithRed:72/255.0 green:187/255.0 blue:192/255.0 alpha:1.0];
        color2 = [UIColor colorWithRed:28/255.0 green:108/255.0 blue:111/255.0 alpha:1.0];
    }else
    {
        color1 = [UIColor colorWithRed:239/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
        color2 = [UIColor colorWithRed:152/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
    }
    UIColor *maskColor = nil;
    if (usage.colorType == TCServerUsageIdle)
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }else if(usage.colorType == TCServerUsageSafe)
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }else if (usage.colorType == TCServerUsageWarning)
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }else if(usage.colorType == TCServerUsageAlert)
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.15];
    }else
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    [_maskView setBackgroundColor:maskColor];

    _gradientLayer.colors = @[(__bridge id)color1.CGColor,
                              (__bridge id)color2.CGColor];
    
    
    //_gradientLayer.locations = @[@(0.0f), @(1.0f)];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
}

- (void) highlight
{
    [_highlightView setHidden:NO];
}

- (void) unhighlight
{
    [_highlightView setHidden:YES];
}

- (NSArray*) usageParamArray
{
    TCServerThreshold *threshold = [[TCConfiguration shared] threshold];
    NSMutableArray *params = [NSMutableArray new];
    CGFloat cpuRate = _usage.cpuUsageRate.floatValue;
    CGFloat memoryRate = _usage.memUsageRate.floatValue;
    CGFloat diskIORate = _usage.diskUtilize.floatValue;
    CGFloat diskUsageRate = _usage.diskUsageRate.floatValue;
    CGFloat netInputRate = 0.0;
    CGFloat netOutputRate = 0.0;
    //CGFloat netUsageRate = 0;
    NSString *netUsageStr = _usage.netUsageRate;
    if (netUsageStr && netUsageStr.length > 0)
    {
        NSArray *netStrArray = [netUsageStr componentsSeparatedByString:@"/"];
        if (netStrArray && netStrArray.count >= 2)
        {
            NSString *str1 = [netStrArray objectAtIndex:0];
            NSString *str2 = [netStrArray objectAtIndex:1];
            netInputRate = str1.floatValue;
            netOutputRate = str2.floatValue;
        }
    }
    NSString *cpuDesc = [NSString stringWithFormat:@"CPU使用率  %g%%",cpuRate];
    NSString *memoryDesc = [NSString stringWithFormat:@"内存使用率  %g%%",memoryRate];
    NSString *diskIODesc = [NSString stringWithFormat:@"磁盘利用率  %g%%",diskIORate];
    NSString *diskDesc = [NSString stringWithFormat:@"磁盘占用率  %g%%",diskUsageRate];
    NSString *netIDesc = [NSString stringWithFormat:@"网络I %@",_usage.netDownload ];
    NSString *netODesc = [NSString stringWithFormat:@"网络O %@",_usage.netUpload];
    //NSString *netIODesc = [NSString stringWithFormat:@"网络I %@  网络O %@",_usage.netUpload, _usage.netDownload];
    NSMutableArray *tmpArray = [NSMutableArray new];
    [tmpArray addObject:cpuDesc];
    [tmpArray addObject:memoryDesc];
    [tmpArray addObject:diskDesc];
    [tmpArray addObject:diskIODesc];
    //[tmpArray addObject:netIODesc];
    [tmpArray addObject:netIDesc];
    [tmpArray addObject:netODesc];
    if (cpuRate >= threshold.cpu_threshold)
    {
        [params addObject:cpuDesc];
        [tmpArray removeObject:cpuDesc];
    }
    if (memoryRate >= threshold.memory_threshold)
    {
        [params addObject:memoryDesc];
        [tmpArray removeObject:memoryDesc];
    }
    if (diskIORate >= threshold.block_threshold)
    {
        [params addObject:diskIODesc];
        [tmpArray removeObject:diskIODesc];
    }
    if (diskUsageRate >= threshold.disk_threshold)
    {
        [params addObject:diskDesc];
        [tmpArray removeObject:diskDesc];
    }
    //if (netUsageRate >= threshold.net_threshold)
    //{
        //[params addObject:netIODesc];
        //[tmpArray removeObject:netIODesc];
    //}
    if (netInputRate >= threshold.net_threshold)
    {
        [params addObject:netIDesc];
        [tmpArray removeObject:netIDesc];
    }
    
    if (netOutputRate >= threshold.net_threshold)
    {
        [params addObject:netODesc];
        [tmpArray removeObject:netODesc];
    }
    
    for (int i = 0; i < tmpArray.count; i++)
    {
        NSString *tmpStr = [tmpArray objectAtIndex:i];
        [params addObject:tmpStr];
    }
    
    return params;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }else if([view isKindOfClass:[UICollectionViewCell class]])
    {
        return self;
    }
    return [super hitTest:point withEvent:event];
}
@end
