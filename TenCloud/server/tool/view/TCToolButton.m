//
//  TCToolButton.m
//  TenCloud
//
//  Created by huangdx on 2018/3/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCToolButton.h"

@implementation TCToolButton

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

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat viewHeight = self.frame.size.height;
    CGFloat imgOffset = viewHeight * 0.18;
    CGFloat titleOffset = viewHeight * 0.18;
    CGFloat imgWidth = self.imageView.frame.size.width;
    CGFloat imgHeight = self.imageView.frame.size.height;
    UIEdgeInsets titleInset = UIEdgeInsetsMake(imgHeight + titleOffset, -imgWidth, 0, 0);
    [self setTitleEdgeInsets:titleInset];
    CGFloat titleWidth = self.titleLabel.bounds.size.width;
    CGFloat titleHeight = self.titleLabel.bounds.size.height;
    //CGFloat imgTopInset = - titleHeight - imgOffset;
    if (titleHeight > TCSCALE(12.075))
    {
        titleHeight = TCSCALE(12.075);
    }
    //NSLog(@"title height:%.2f vh:%.2f",titleHeight,viewHeight);
    //NSLog(@"imgHeight:%.2f",imgHeight);
    //NSLog(@"btn%@img top inset:%.2f",self.titleLabel.text, imgTopInset);
    UIEdgeInsets imgInset = UIEdgeInsetsMake(-titleHeight - imgOffset, 0, 0, -titleWidth);
    [self setImageEdgeInsets:imgInset];
}

@end
