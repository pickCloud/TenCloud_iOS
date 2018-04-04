//
//  TCSelectTagLabelCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSelectTagLabelCell.h"

@interface TCSelectTagLabelCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@end

@implementation TCSelectTagLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = TCSCALE(2.0);
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = THEME_TEXT_COLOR.CGColor;
    _nameLabel.textColor = THEME_TEXT_COLOR;
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = TCFont(12.);
}

- (void) setName:(NSString*)name
{
    _nameLabel.text = name;
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (self.selected)
    {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        _nameLabel.textColor = THEME_TINT_COLOR;
        self.backgroundColor = STATE_NORMAL_BG_COLOR;
    }else
    {
        self.layer.borderColor = THEME_PLACEHOLDER_COLOR.CGColor;
        _nameLabel.textColor = THEME_PLACEHOLDER_COLOR;
        self.backgroundColor = [UIColor clearColor];
    }
}
@end
