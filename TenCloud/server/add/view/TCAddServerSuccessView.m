//
//  TCAddServerSuccessView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAddServerSuccessView.h"
@interface TCAddServerSuccessView()
- (IBAction) onContinueButton:(id)sender;
- (IBAction) onCheckButton:(id)sender;
@end

@implementation TCAddServerSuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction) onContinueButton:(id)sender
{
    if (_continueBlock)
    {
        _continueBlock();
    }
}

- (IBAction) onCheckButton:(id)sender
{
    if (_checkBlock)
    {
        _checkBlock();
    }
}
@end
