//
//  TCTimeTagLabel.m
//  TenCloud
//
//  Created by huangdx on 2018/1/24.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCTimeTagLabel.h"

@implementation TCTimeTagLabel

- (void) initUI
{
    self.edgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    self.layer.cornerRadius = 2.0;
    self.clipsToBounds = YES;
    self.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
    self.textColor = THEME_PLACEHOLDER_COLOR;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize labelSize = self.frame.size;
    self.layer.cornerRadius = labelSize.height/2.0;
}

@end
