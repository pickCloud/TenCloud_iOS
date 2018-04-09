//
//  SBAProviderTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBAProviderTableViewCell.h"
#import "TCCloud+CoreDataClass.h"

@interface SBAProviderTableViewCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIImageView *iconView;
@property (nonatomic, weak) IBOutlet    UIImageView *selectedView;
@end

@implementation SBAProviderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected)
    {
        [_selectedView setHidden:NO];
    }else
    {
        [_selectedView setHidden:YES];
    }
}

- (void) setCloud:(TCCloud*)cloud
{
    _nameLabel.text = cloud.name;
    UIImage *img = [UIImage imageNamed:cloud.icon];
    if (img)
    {
        [_iconView setImage:img];
    }
}

@end
