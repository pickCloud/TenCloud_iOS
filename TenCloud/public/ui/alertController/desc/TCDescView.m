//
//  TCDescView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCDescView.h"
#import "UIView+TCAlertView.h"

@interface TCDescView()
@property (nonatomic, weak) IBOutlet    UILabel     *textLabel;
@property (nonatomic, weak) IBOutlet    UITextView  *descView;
- (IBAction) onOkButton:(id)sender;
@end

@implementation TCDescView

/*
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //此处设置无效
        //[_descView setTextColor:THEME_PLACEHOLDER_COLOR];
        [_descView setTextColor:[UIColor redColor]];
        NSLog(@"红色字体！！！！！");
    }
    return self;
}
 */

- (void) layoutSubviews
{
    [super layoutSubviews];
    //此代码仅为修复iOS10下字体颜色为黑色的问题
    [_descView setTextColor:THEME_PLACEHOLDER_COLOR];
}

- (void) setDesc:(NSString *)desc
{
    _descView.text = desc;
}

- (void) setTitle:(NSString *)title
{
    _textLabel.text = title;
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
