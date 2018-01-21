//
//  TCPermissionItemCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPermissionItemCell.h"
#import "TCPermissionNode+CoreDataClass.h"


@interface TCPermissionItemCell()
@property (nonatomic, weak) TCPermissionNode        *node;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *checkButton;
- (IBAction) onSelectButton:(id)sender;
- (void) updateSelectButtonUI;
@end

@implementation TCPermissionItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setNode:(TCPermissionNode *)node
{
    _nameLabel.text = node.name;
    _node = node;
    [self updateSelectButtonUI];
}

- (IBAction) onSelectButton:(id)sender
{
    NSLog(@"select button");
    /*
    self.item.selected = !self.item.selected;
    [self updateSelectButtonUI];
    if (_selectBlock)
    {
        _selectBlock(self, self.item.selected);
    }
     */
    self.node.selected = !self.node.selected;
    [self updateSelectButtonUI];
    if (_selectBlock)
    {
        _selectBlock(self, self.node.selected);
    }
}

- (void) updateSelectButtonUI
{
    if (self.node.selected)
    {
        UIImage *selectedImage = [UIImage imageNamed:@"template_checked"];
        [_checkButton setImage:selectedImage forState:UIControlStateNormal];
        _nameLabel.textColor = THEME_TINT_COLOR;
    }else
    {
        UIImage *unselectedImage = [UIImage imageNamed:@"template_unchecked"];
        [_checkButton setImage:unselectedImage forState:UIControlStateNormal];
        _nameLabel.textColor = THEME_TEXT_COLOR;
    }
}
@end
