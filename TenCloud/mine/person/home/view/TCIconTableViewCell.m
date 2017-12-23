//
//  TCIconTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/22.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCIconTableViewCell.h"

@interface TCIconTableViewCell()
@property (nonatomic, weak) IBOutlet    UIImageView     *iconImageView;
@property (nonatomic, weak) IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *descLabel;
@end

@implementation TCIconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:30/255.0 green:32/255.0 blue:44/255.0 alpha:1];
    self.selectedBackgroundView = selectedBgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIcon:(NSString*)iconName title:(NSString*)title desc:(NSString*)desc
{
    UIImage *iconImage = [UIImage imageNamed:iconName];
    _iconImageView.image = iconImage;
    _nameLabel.text = title;
    _descLabel.text = desc;
}
@end
