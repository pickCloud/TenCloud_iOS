//
//  SBAAddingView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBAAddingView.h"
#import "UIView+TCAlertView.h"
#import "TCDonutChartView.h"

@interface SBAAddingView()
@property (nonatomic, weak) IBOutlet    UILabel             *progressLabel;
@property (nonatomic, weak) IBOutlet    TCDonutChartView    *donutView;
@property (nonatomic, weak) IBOutlet    UILabel             *descLabel;
@end

@implementation SBAAddingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) awakeFromNib
{
    [super awakeFromNib];
    UIColor *grayColor = [UIColor colorWithRed:64/255.0 green:70/255.0 blue:85/255.0 alpha:1.0];
    _donutView.bgColor = grayColor;
    //_donutView.percent = 0.25;
}

- (void) setProgress:(CGFloat)progress
               total:(NSInteger)totalNum
             success:(NSInteger)sucNum
                fail:(NSInteger)failNum
{
    NSString *progStr = [NSString stringWithFormat:@"%g%%",progress*100];
    _progressLabel.text = progStr;
    [_donutView setPercent:progress];
    NSMutableAttributedString *desc = [NSMutableAttributedString new];
    UIFont *textFont = TCFont(14.0);
    NSDictionary *grayAttr = @{NSForegroundColorAttributeName : THEME_PLACEHOLDER_COLOR,
                               NSFontAttributeName : textFont };
    NSDictionary *greenAttr = @{NSForegroundColorAttributeName : THEME_TINT_COLOR,
                                NSFontAttributeName : textFont };
    NSDictionary *pinkAttr = @{NSForegroundColorAttributeName : STATE_ALERT_COLOR,
                               NSFontAttributeName : textFont };
    NSString *str1 = [NSString stringWithFormat:@"共 %ld 台：已导入 ",totalNum];
    NSMutableAttributedString *tmp1 = nil;
    tmp1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:grayAttr];
    NSString *str2 = [NSString stringWithFormat:@"%ld",sucNum];
    NSMutableAttributedString *tmp2 = nil;
    tmp2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:greenAttr];
    NSString *str3 = [NSString stringWithFormat:@" 台 / 失败 "];
    NSMutableAttributedString *tmp3 = nil;
    tmp3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:grayAttr];
    NSString *str4 = [NSString stringWithFormat:@"%ld",failNum];
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
    _descLabel.attributedText = desc;
    
}

@end
