//
//  TCAppProfileTaskCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAppProfileTaskCell.h"
#import "TCTask+CoreDataClass.h"
#import "TCIconStatusLabel.h"
#import "NSString+Extension.h"

@interface TCAppProfileTaskCell ()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIView      *bgView;
@property (nonatomic, weak) IBOutlet    UILabel     *startTimeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *endTimeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *progressLabel;
- (void) updateUI;
@end

@implementation TCAppProfileTaskCell

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

- (void) setTask:(TCTask*)task
{
    _nameLabel.text = task.name;
    NSString *progressStr = [NSString stringWithFormat:@"%g%%",task.progress*100];
    _progressLabel.text = progressStr;
    NSString *startTimeStr = [NSString dateTimeStringFromTimeInterval:task.startTime];
    _startTimeLabel.text = startTimeStr;
    NSString *endTimeStr = [NSString dateTimeStringFromTimeInterval:task.endTime];
    _endTimeLabel.text = endTimeStr;
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
