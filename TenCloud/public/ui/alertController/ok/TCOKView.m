//
//  TCOKView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCOKView.h"
#import "UIView+TCAlertView.h"

@interface TCOKView()
@property (nonatomic, weak) IBOutlet    UILabel     *textLabel;
- (IBAction) onOkButton:(id)sender;
@end

@implementation TCOKView

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

- (void) setAttrText:(NSAttributedString *)attrText
{
    _textLabel.attributedText = attrText;
}

- (IBAction) onOkButton:(id)sender
{
    [self hideView];
    if (_okBlock)
    {
        _okBlock(self);
    }
}

- (void) setAlignment:(NSTextAlignment)alignment
{
    [_textLabel setTextAlignment:alignment];
}
@end
