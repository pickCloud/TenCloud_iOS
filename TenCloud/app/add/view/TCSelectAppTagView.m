//
//  TCSelectAppTagView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCSelectAppTagView.h"
#import "UIView+TCAlertView.h"

@interface TCSelectAppTagView()
- (IBAction) onOkButton:(id)sender;
@end

@implementation TCSelectAppTagView

- (IBAction) onOkButton:(id)sender
{
    [self hideView];

    if (_resultBlock)
    {
        _resultBlock(self, @[]);
    }
}
@end
