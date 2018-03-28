//
//  TCBarChartView.m
//  TestChart
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//

#define LINE_WIDTH      4.0

#import "TCBarChartView.h"
@interface TCBarChartView()
@property (nonatomic, strong) CALayer *foreLayer;
- (void) redraw;
@end

@implementation TCBarChartView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _foregroundColor = THEME_TINT_COLOR;
        
        [self setBackgroundColor:THEME_NAVBAR_TITLE_COLOR];
        
        [self redraw];
        
    }
    return self;
}

- (void) redraw
{
    if (_foreLayer)
    {
        [_foreLayer removeFromSuperlayer];
    }
    
    CGRect gRect = self.bounds;
    CGFloat height = gRect.size.height * _percent;
    CGRect foreRect = CGRectMake(0, gRect.size.height - height, gRect.size.width, height);
    _foreLayer = [CALayer layer];
    _foreLayer.frame = foreRect;
    _foreLayer.backgroundColor = _foregroundColor.CGColor;
    [self.layer addSublayer:_foreLayer];
}

- (void) setPercent:(CGFloat)percent
{
    _percent = percent;
    [self redraw];
}

- (void) setForegroundColor:(UIColor*)foreColor
{
    _foregroundColor = foreColor;
    [self redraw];
}

@end
