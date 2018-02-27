//
//  TCServerContainerTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerContainerTableViewCell.h"


@interface TCServerContainerTableViewCell ()
@property (nonatomic, weak) IBOutlet    UIView      *bg2View;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *statusLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *containerIDLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *timeLabel;
- (void) updateUI;
@end

@implementation TCServerContainerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.02];
    self.selectedBackgroundView = selectedBgView;
    self.bg2View.layer.cornerRadius = TCSCALE(2.0);
    self.nameLabel.font = TCFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self updateUI];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateUI];
}

- (void) setContainer:(NSArray<NSString*> *)strArray
{
    if (strArray && strArray.count >= 4)
    {
        NSString *containerID = [strArray objectAtIndex:0];
        NSString *name = [strArray objectAtIndex:1];
        NSString *status = [strArray objectAtIndex:2];
        NSString *timeStr = [strArray objectAtIndex:3];
        _nameLabel.text = name;
        _statusLabel.text = status;
        _containerIDLabel.text = containerID;
        _timeLabel.text = timeStr;
    }
}

- (void) updateUI
{
    if (self.selected)
    {
        self.bg2View.backgroundColor = [UIColor redColor]; //TABLE_CELL_BG_COLOR;
    }else
    {
        self.bg2View.backgroundColor = TABLE_CELL_BG_COLOR;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}
@end
