//
//  SBAFailView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBAFailView.h"
#import "UIView+TCAlertView.h"

@interface SBAFailView()
@property (nonatomic, weak) IBOutlet    UILabel     *textLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *confirmButton;
- (IBAction) onCancelButton:(id)sender;
- (IBAction) onConfirmButton:(id)sender;
@end

@implementation SBAFailView

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
    if (_retryBlock)
    {
        _retryBlock(self);
    }
}

- (void) setTotalAmount:(NSInteger)total
                success:(NSInteger)success
                   fail:(NSInteger)fail
{
    NSMutableAttributedString *desc = [NSMutableAttributedString new];
    UIFont *textFont = TCFont(14.0);
    NSDictionary *grayAttr = @{NSForegroundColorAttributeName : THEME_PLACEHOLDER_COLOR,
                               NSFontAttributeName : textFont };
    NSDictionary *greenAttr = @{NSForegroundColorAttributeName : THEME_TINT_COLOR,
                                NSFontAttributeName : textFont };
    NSDictionary *pinkAttr = @{NSForegroundColorAttributeName : STATE_ALERT_COLOR,
                               NSFontAttributeName : textFont };
    NSString *str1 = [NSString stringWithFormat:@"共 %ld 台：已导入 ",total];
    NSMutableAttributedString *tmp1 = nil;
    tmp1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:grayAttr];
    NSString *str2 = [NSString stringWithFormat:@"%ld",success];
    NSMutableAttributedString *tmp2 = nil;
    tmp2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:greenAttr];
    NSString *str3 = [NSString stringWithFormat:@" 台 / 失败 "];
    NSMutableAttributedString *tmp3 = nil;
    tmp3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:grayAttr];
    NSString *str4 = [NSString stringWithFormat:@"%ld",fail];
    NSMutableAttributedString *tmp4 = nil;
    tmp4 = [[NSMutableAttributedString alloc] initWithString:str4 attributes:pinkAttr];
    NSString *str5 = @" 台";
    NSMutableAttributedString *tmp5 = nil;
    tmp5 = [[NSMutableAttributedString alloc] initWithString:str5 attributes:grayAttr];
    [desc appendAttributedString:tmp1];
    [desc appendAttributedString:tmp2];
    [desc appendAttributedString:tmp3];
    [desc appendAttributedString:tmp4];
    [desc appendAttributedString:tmp5];
    _textLabel.attributedText = desc;
}
@end
