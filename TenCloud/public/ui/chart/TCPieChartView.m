//
//  TCPieChartView.m
//  TestChart
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//


#define LINE_WIDTH      4.0

#import "TCPieChartView.h"
@interface TCPieChartView()
@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) CAShapeLayer *foreLayer;
- (void) redraw;
@end

@implementation TCPieChartView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _foregroundColor = THEME_TINT_COLOR;
        
        CGRect rect = self.bounds;
        CGRect gRect = CGRectMake(rect.origin.x, rect.origin.y,
                                  TCSCALE(rect.size.width), TCSCALE(rect.size.height));
        NSLog(@"grect:%.2f,%.2f,%.2f,%.2f",gRect.origin.x,gRect.origin.y,
              gRect.size.width, gRect.size.height);
        CGPoint center = CGPointMake(gRect.size.width * 0.5, gRect.size.height * 0.5);
        CGFloat radius = gRect.size.width * 0.5 - LINE_WIDTH/2.0;
        UIBezierPath *piePath = [UIBezierPath bezierPath];
        [piePath moveToPoint:center];
        [piePath addArcWithCenter:center radius:radius startAngle:M_PI endAngle:M_PI*3 clockwise:YES];
        
        CAShapeLayer *shapelayer = [CAShapeLayer layer];
        _bgLayer = shapelayer;
        shapelayer.lineWidth = 0.0;LINE_WIDTH;
        shapelayer.strokeColor = THEME_NAVBAR_TITLE_COLOR.CGColor;
        shapelayer.fillColor = THEME_NAVBAR_TITLE_COLOR.CGColor;
        shapelayer.path = piePath.CGPath;
        
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
    CGPoint center = CGPointMake(gRect.size.width * 0.5, gRect.size.height * 0.5);
    CGFloat radius = gRect.size.width * 0.5 - LINE_WIDTH/2.0;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 2 * M_PI * ( _percent) -M_PI_2;
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    [piePath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    _foreLayer = shapelayer;
    shapelayer.lineWidth = 0.0;//LINE_WIDTH;
    shapelayer.strokeColor = _foregroundColor.CGColor;
    shapelayer.fillColor = _foregroundColor.CGColor;
    shapelayer.path = piePath.CGPath;
    
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
