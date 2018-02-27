//
//  TCAddServerFailView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAddServerFailView.h"
#import "UIView+TCAlertView.h"

@implementation TCAddServerFailView

- (IBAction) onContinueButton:(id)sender
{
    [self hideView];
    if (_continueBlock)
    {
        _continueBlock();
    }
}
@end
