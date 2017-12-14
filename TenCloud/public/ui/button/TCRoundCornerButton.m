//
//  TCRoundCornerButton.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCRoundCornerButton.h"

@implementation TCRoundCornerButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    //CGSize btnSize = self.frame.size;
    self.layer.cornerRadius = TCSCALE(4.0); //btnSize.height / 2.0;
    self.clipsToBounds = NO;
}

@end
