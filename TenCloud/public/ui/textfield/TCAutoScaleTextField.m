//
//  TCAutoScaleTextField.m
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAutoScaleTextField.h"

@implementation TCAutoScaleTextField

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
- (BOOL) canBecomeFirstResponder
{
    //[super canBecomeFirstResponder];
    return YES;
}
 */

@end
