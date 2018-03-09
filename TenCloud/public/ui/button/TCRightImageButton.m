//
//  TCRightImageButton.m
//  TenCloud
//
//  Created by huangdx on 2018/3/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCRightImageButton.h"

@implementation TCRightImageButton

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
    CGFloat imgWidth = self.imageView.frame.size.width;
    UIEdgeInsets titleInset = UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth);
    [self setTitleEdgeInsets:titleInset];
    CGFloat titleWidth = self.titleLabel.bounds.size.width;
    UIEdgeInsets imgInset = UIEdgeInsetsMake(0, titleWidth, 0, -titleWidth);
    [self setImageEdgeInsets:imgInset];
}

@end
