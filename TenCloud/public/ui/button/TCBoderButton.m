//
//  TCBoderButton.m
//  TenCloud
//
//  Created by huangdx on 2018/1/25.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCBoderButton.h"

@implementation TCBoderButton

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:THEME_TINT_COLOR.CGColor];
        [self setTitleColor:THEME_TINT_COLOR forState:UIControlStateNormal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
