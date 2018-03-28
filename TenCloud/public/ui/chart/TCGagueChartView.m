//
//  TCGagueChartView.m
//  TestChart
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//


#define LINE_WIDTH      4.0

#import "TCGagueChartView.h"
@interface TCGagueChartView()
@property (nonatomic, strong) CAShapeLayer *outerCircleLayer;
@property (nonatomic, strong) CAShapeLayer *foreLayer;
- (void) redraw;
@end

@implementation TCGagueChartView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _foregroundColor = THEME_TINT_COLOR;
        
        CGRect rect = self.bounds;
        CGRect gRect = CGRectMake(rect.origin.x, rect.origin.y,
                           TCSCALE(rect.size.width), TCSCALE(rect.size.height));
        NSLog(@"grect1:%.2f,%.2f,%.2f,%.2f",gRect.origin.x,gRect.origin.y,
              gRect.size.width, gRect.size.height);
        CGPoint center = CGPointMake(gRect.size.width * 0.5, gRect.size.height);
        CGFloat radius = gRect.size.width * 0.5 - LINE_WIDTH/2.0;
        UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle: 0 clockwise:YES];
        
        CAShapeLayer *shapelayer = [CAShapeLayer layer];
        _outerCircleLayer = shapelayer;
        shapelayer.lineWidth = LINE_WIDTH;
        shapelayer.strokeColor = THEME_NAVBAR_TITLE_COLOR.CGColor;
        shapelayer.fillColor = [UIColor clearColor].CGColor;
        shapelayer.path = arcPath.CGPath;
        
        [self.layer addSublayer:shapelayer];
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
    NSLog(@"grect2:%.2f,%.2f,%.2f,%.2f",gRect.origin.x,gRect.origin.y,
          gRect.size.width, gRect.size.height);
    CGPoint center = CGPointMake(gRect.size.width * 0.5, gRect.size.height);
    CGFloat radius = gRect.size.width * 0.5 - LINE_WIDTH/2.0;
    CGFloat endAngle = - M_PI * (1 - _percent);
    UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle: endAngle clockwise:YES];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    _foreLayer = shapelayer;
    shapelayer.lineWidth = LINE_WIDTH;
    shapelayer.strokeColor = _foregroundColor.CGColor;
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.path = arcPath.CGPath;
    
    [self.layer addSublayer:shapelayer];
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
