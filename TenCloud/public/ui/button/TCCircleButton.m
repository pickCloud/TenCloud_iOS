//
//  TCCircleButton.m
//  TenCloud
//
//  Created by huangdx on 2017/12/26.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCircleButton.h"

@implementation TCCircleButton

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    self.layer.cornerRadius = self.bounds.size.width/2.0;
    [super layoutSubviews];
}

@end
