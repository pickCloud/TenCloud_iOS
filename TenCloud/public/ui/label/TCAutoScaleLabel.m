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
        //CGFloat fontSize = TCSCALE(self.font.pointSize);
        //self.font = [UIFont systemFontOfSize:fontSize];
        UIFontDescriptor *fontDesc = self.font.fontDescriptor;
        CGFloat newSize = TCSCALE(fontDesc.pointSize);
        UIFontDescriptor *newDesc = [fontDesc fontDescriptorWithSize:newSize];
        UIFont *newFont = [UIFont fontWithDescriptor:newDesc size:newSize];
        self.font = newFont;
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
