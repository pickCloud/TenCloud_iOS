//
//  YEProfileTableViewCell.m
//  YE
//
//  Created by huangdx on 2017/10/24.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "TCServerConfigTableViewCell.h"
#define BUTTON_FONT_SIZE        16.0

@interface TCServerConfigTableViewCell()
@property (nonatomic, weak) IBOutlet    UILabel             *keyLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *valueLabel;
@property (nonatomic, weak) IBOutlet    UIButton            *disclosureButton;
@end

@implementation TCServerConfigTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.keyLabel setFont:TCFont(14)];
    [self.valueLabel setFont:TCFont(14)];
    

    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.02];
    self.selectedBackgroundView = selectedBgView;
    
    self.backgroundColor = TABLE_CELL_BG_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setKey:(NSString*)key value:(NSString*)value
{
    [self setKey:key value:value disclosure:NO];
}

- (void) setKey:(NSString*)key value:(NSString*)value disclosure:(BOOL)disclosure
{
    _keyLabel.text = key;
    _valueLabel.text = value;
    _disclosureButton.hidden = !disclosure;
}

@end
