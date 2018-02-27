//
//  TCAddServerSuccessView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAddServerSuccessView.h"
#import "UIView+TCAlertView.h"
@interface TCAddServerSuccessView()
- (IBAction) onContinueButton:(id)sender;
- (IBAction) onCheckButton:(id)sender;
@end

@implementation TCAddServerSuccessView

- (IBAction) onContinueButton:(id)sender
{
    [self hideView];
    if (_continueBlock)
    {
        _continueBlock();
    }
}

- (IBAction) onCheckButton:(id)sender
{
    [self hideView];
    if (_checkBlock)
    {
        _checkBlock();
    }
}
@end
