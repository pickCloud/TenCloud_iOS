//
//  TCServerStateTableViewCell.m
//  YE
//
//  Created by huangdx on 2017/10/24.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "TCServerStateTableViewCell.h"
#define BUTTON_FONT_SIZE        16.0


@interface TCServerStateTableViewCell()
@property (nonatomic, weak) IBOutlet    UILabel             *keyLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *valueLabel;
@property (nonatomic, weak) IBOutlet    UIView              *stateBackgroundView;
@property (nonatomic, weak) IBOutlet    UIButton            *disclosureButton;
@end

@implementation TCServerStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.keyLabel setFont:TCFont(14)];
    [self.valueLabel setFont:TCFont(10)];
    _stateBackgroundView.clipsToBounds = YES;

    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.02];
    self.selectedBackgroundView = selectedBgView;
    self.backgroundColor = TABLE_CELL_BG_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setKey:(NSString*)key value:(NSString*)value disclosure:(BOOL)disclosure
{
    _keyLabel.text = key;
    [self setStateValue:value];
    _disclosureButton.hidden = !disclosure;
}

- (void) setStateValue:(NSString*)value
{
    [_valueLabel setText:value];
    if ([value containsString:@"已停止"] ||
        [value containsString:@"已关机"] )
    {
        [_valueLabel setTextColor:STATE_ALERT_COLOR];
        [_stateBackgroundView setBackgroundColor:STATE_ALERT_BG_COLOR];
    }else if([value containsString:@"异常"])
    {
        [_valueLabel setTextColor:STATE_ERROR_COLOR];
        [_stateBackgroundView setBackgroundColor:STATE_ERROR_BG_COLOR];
    }else
    {
        [_valueLabel setTextColor:STATE_NORMAL_COLOR];
        [_stateBackgroundView setBackgroundColor:STATE_NORMAL_BG_COLOR];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize stateBgSize = self.stateBackgroundView.bounds.size;
    _stateBackgroundView.layer.cornerRadius = stateBgSize.height/2.0;
}

@end
