//
//  TCAutoScaleLabel.m
//  TenCloud
//
//  Created by huangdx on 2018/3/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAutoScaleLabel.h"

@implementation TCAutoScaleLabel

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        CGFloat fontSize = TCSCALE(self.font.pointSize);
        self.font = [UIFont systemFontOfSize:fontSize];
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
