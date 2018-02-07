//
//  TCPermissionTemplateCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPermissionTemplateCell.h"

@interface TCPermissionTemplateCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIImageView *selectedIconView;
@end

@implementation TCPermissionTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4.0;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    _nameLabel.textColor = THEME_PLACEHOLDER_COLOR;
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
        _selectedIconView.hidden = NO;
        _nameLabel.textColor = THEME_TINT_COLOR;
        self.layer.borderColor = THEME_TINT_COLOR.CGColor;
    }else
    {
        _selectedIconView.hidden = YES;
        _nameLabel.textColor = THEME_PLACEHOLDER_COLOR;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}
@end
