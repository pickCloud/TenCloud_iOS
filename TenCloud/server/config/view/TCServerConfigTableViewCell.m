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
@end

@implementation TCServerConfigTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    NSLog(@"selected once:%d",selected);
}

- (void) setKey:(NSString*)key value:(NSString*)value
{
    _keyLabel.text = key;
    _valueLabel.text = value;
}

@end
