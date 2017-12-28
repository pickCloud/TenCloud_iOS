//
//  TCSwitchAccountButton.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSwitchAccountButton.h"

@interface TCSwitchAccountButton()
@property (nonatomic, weak) IBOutlet    UIView      *contentView;
@property (nonatomic, weak) IBOutlet    UILabel     *textLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *realButton;
- (IBAction) onButton:(id)sender;
@end

@implementation TCSwitchAccountButton

 - (void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"TCSwitchAccountButton" owner:self options:nil];
    [self addSubview:_contentView];
    _textLabel.font = TCFont(11.0);
}

/*
- (void) addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_realButton addTarget:target action:action forControlEvents:controlEvents];
}
 */

- (IBAction) onButton:(id)sender
{
    NSLog(@"优雅的按下3");
    self.checked = !_checked;
    [self setNeedsDisplay];
    if (_touchedBlock)
    {
        _touchedBlock();
    }
}

- (void) setChecked:(BOOL)checked
{
    _checked = checked;
    if (_checked)
    {
        _contentView.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
    }else
    {
        _contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)layoutSubviews
{
    _contentView.layer.cornerRadius = _contentView.bounds.size.height/2.0;
    [super layoutSubviews];
}
@end
