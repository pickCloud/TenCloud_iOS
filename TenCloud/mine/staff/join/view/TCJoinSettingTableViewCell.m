//
//  TCJoinSettingTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2018/1/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCJoinSettingTableViewCell.h"

@interface TCJoinSettingTableViewCell()
@property (nonatomic, weak) IBOutlet    UIImageView *checkBoxView;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *requiredLabel;
@property (nonatomic, weak) TCJoinSettingItem       *item;
@end

@implementation TCJoinSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    /*
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
     */
    self.multipleSelectionBackgroundView = [UIView new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (_item.required)
    {
        return;
    }
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected)
    {
        UIImage *checkBoxImg = [UIImage imageNamed:@"checkbox_circle"];
        [_checkBoxView setImage:checkBoxImg];
    }else
    {
        UIImage *uncheckBoxImg = [UIImage imageNamed:@"checkbox_circle_un"];
        [_checkBoxView setImage:uncheckBoxImg];
    }
}

- (void) setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void) setItem:(TCJoinSettingItem*)item
{
    _item = item;
    _nameLabel.text = item.name;
    _requiredLabel.hidden = !item.required;
}

@end
