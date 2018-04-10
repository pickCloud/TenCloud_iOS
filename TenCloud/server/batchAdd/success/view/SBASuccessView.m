//
//  SBASuccessView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBASuccessView.h"
#import "UIView+TCAlertView.h"

@interface SBASuccessView()
@property (nonatomic, weak) IBOutlet    UILabel     *textLabel;
- (IBAction) onOkButton:(id)sender;
@end

@implementation SBASuccessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setImportServerAmount:(NSInteger)importServerAmount
{
    NSString *text = [NSString stringWithFormat:@"共成功导入%ld台云主机",importServerAmount];
    _textLabel.text = text;
}

/*
- (void) setText:(NSString *)text
{
    _textLabel.text = text;
}

- (void) setAttrText:(NSAttributedString *)attrText
{
    _textLabel.attributedText = attrText;
}
 
- (void) setAlignment:(NSTextAlignment)alignment
{
    [_textLabel setTextAlignment:alignment];
}
 */

- (IBAction) onOkButton:(id)sender
{
    [self hideView];
    if (_successBlock)
    {
        _successBlock(self);
    }
}


@end
