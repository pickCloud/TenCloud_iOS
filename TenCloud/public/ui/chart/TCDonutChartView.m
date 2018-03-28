//
//  TCDonutChartView.m
//  TestChart
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//

#define LINE_WIDTH      4.0

#import "TCDonutChartView.h"
@interface TCDonutChartView()
@property (nonatomic, strong) CAShapeLayer *outerCircleLayer;
@property (nonatomic, strong) CAShapeLayer *foreLayer;
- (void) redraw;
@end

@implementation TCDonutChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
        UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle: 3*M_PI clockwise:YES];
        
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
    CGPoint center = CGPointMake(gRect.size.width * 0.5, gRect.size.height * 0.5);
    CGFloat radius = gRect.size.width * 0.5 - LINE_WIDTH/2.0;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 2 * M_PI * ( _percent) -M_PI_2;
    UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle: endAngle clockwise:YES];
    
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
