//
//  TCConfirmView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCConfirmView.h"
#import "UIView+TCAlertView.h"

@interface TCConfirmView()
@property (nonatomic, weak) IBOutlet    UILabel     *textLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *confirmButton;
- (IBAction) onCancelButton:(id)sender;
- (IBAction) onConfirmButton:(id)sender;
@end

@implementation TCConfirmView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) setText:(NSString *)text
{
    _textLabel.text = text;
}

- (void) setConfirmButtonName:(NSString *)confirmButtonName
{
    [_confirmButton setTitle:confirmButtonName forState:UIControlStateNormal];
}

- (IBAction) onCancelButton:(id)sender
{
    [self hideView];
    if (_cancelBlock)
    {
        _cancelBlock(self);
    }
}

- (IBAction) onConfirmButton:(id)sender
{
    [self hideView];
    if (_confirmBlock)
    {
        _confirmBlock(self);
    }
}

@end
