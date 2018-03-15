//
//  TCServerUsageCollectionCell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerUsageCollectionCell.h"
#import "TCServerUsage+CoreDataClass.h"

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
    if (usage.type == TCServerUsageIdle)
    {
        color1 = [UIColor colorWithRed:86/255.0 green:98/255.0 blue:120/255.0 alpha:1.0];
        color2 = [UIColor colorWithRed:38/255.0 green:42/255.0 blue:53/255.0 alpha:1.0];
    }else if(usage.type == TCServerUsageSafe)
    {
        color1 = [UIColor colorWithRed:72/255.0 green:187/255.0 blue:192/255.0 alpha:1.0];
        color2 = [UIColor colorWithRed:28/255.0 green:108/255.0 blue:111/255.0 alpha:1.0];
    }else
    {
        color1 = [UIColor colorWithRed:239/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
        color2 = [UIColor colorWithRed:152/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
    }
    UIColor *maskColor = nil;
    if (usage.type == TCServerUsageIdle)
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }else if(usage.type == TCServerUsageSafe)
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }else if (usage.type == TCServerUsageWarning)
    {
        maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }else if(usage.type == TCServerUsageAlert)
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
@end
