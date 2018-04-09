//
//  TCAutoScaleButton.m
//  TenCloud
//
//  Created by huangdx on 2018/3/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAutoScaleButton.h"

@implementation TCAutoScaleButton

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        CGFloat fontSize = TCSCALE(self.titleLabel.font.pointSize);
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

@end
