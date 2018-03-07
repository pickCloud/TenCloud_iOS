//
//  TCTextRefreshHeader.m
//  TenCloud
//
//  Created by hdx on 2017/9/17.
//  Copyright © 2017年 ksrsj.com. All rights reserved.
//

#import "TCTextRefreshHeader.h"

@interface TCTextRefreshHeader ()
@property (weak, nonatomic) UILabel *label;
@end

@implementation TCTextRefreshHeader

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = THEME_TEXT_COLOR;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"下拉刷新";
            break;
        case MJRefreshStatePulling:
            self.label.text = @"释放刷新";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载中";
            break;
        default:
            break;
    }
}

/*
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
    CGFloat red = 1.0 - pullingPercent * 0.5;
    CGFloat green = 0.5 - 0.5 * pullingPercent;
    CGFloat blue = 0.5 * pullingPercent;
    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
 */

@end
