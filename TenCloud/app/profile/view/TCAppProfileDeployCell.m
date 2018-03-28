//
//  TCAppProfileDeployCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAppProfileDeployCell.h"
#import "TCDeploy+CoreDataClass.h"
#import "TCIconStatusLabel.h"
#import "NSString+Extension.h"

@interface TCAppProfileDeployCell ()
@property (nonatomic, strong)   TCDeploy              *deploy;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIView      *bgView;
@property (nonatomic, weak) IBOutlet    UILabel     *createTimeLabel;
@property (nonatomic, weak) IBOutlet    TCIconStatusLabel   *statusLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *sourceLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *presetPodLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *currentPodLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *updatePodLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *availablePodLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *runtimeLabel;
- (void) updateUI;
@end

@implementation TCAppProfileDeployCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bgView.layer.cornerRadius = TCSCALE(2.0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self updateUI];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateUI];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    //[self updateUI];
}

- (void) setDeploy:(TCDeploy*)deploy
{
    _nameLabel.text = deploy.name;
    _createTimeLabel.text = [NSString dateTimeStringFromTimeInterval:deploy.createTime];
    //_sourceLabel.text = deploy
    _statusLabel.text = deploy.status;
}

- (void) updateUI
{
    if (self.highlighted)
    {
        self.bgView.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
    }else
    {
        self.bgView.backgroundColor = TABLE_CELL_BG_COLOR;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

@end
