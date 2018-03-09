//
//  TCRoundRectBorderLabel.m
//  TenCloud
//
//  Created by huangdx on 2018/3/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCRoundRectBorderLabel.h"

@implementation TCRoundRectBorderLabel

- (void) initUI
{
    self.edgeInsets = UIEdgeInsetsMake(1.8, 4, 1.8, 4);
    //UIEdgeInsetsMake(1, 2, 1, 2);
    self.layer.cornerRadius = TCSCALE(2.0);//4.0;
    self.clipsToBounds = YES;
    self.layer.borderColor = THEME_TINT_COLOR.CGColor;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0.64;
    self.textColor = THEME_TINT_COLOR;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end
