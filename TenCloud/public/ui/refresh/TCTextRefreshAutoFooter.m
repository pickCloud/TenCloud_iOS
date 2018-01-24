//
//  TCTextRefreshAutoFooter.m
//  TenCloud
//
//  Created by hdx on 2017/9/17.
//  Copyright © 2017年 ksrsj.com. All rights reserved.
//

#import "TCTextRefreshAutoFooter.h"

@interface TCTextRefreshAutoFooter ()
@property (weak, nonatomic) UILabel *label;
@end

@implementation TCTextRefreshAutoFooter

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = THEME_PLACEHOLDER_COLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = self.bounds;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉刷新";
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"加载数据中";
            break;
        case MJRefreshStateNoMoreData:
            self.label.text = @"木有数据了";
            break;
        default:
            break;
    }
}

@end
