//
//  TCMyCorpTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMyCorpTableViewCell.h"
#import "TCCorp+CoreDataClass.h"

@interface TCMyCorpTableViewCell()
@property (nonatomic, weak) IBOutlet    UIView      *bgView;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *statusLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *applyTimeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *reviewTimeLabel;
- (void) updateUI;
@end

@implementation TCMyCorpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bgView.layer.cornerRadius = TCSCALE(2.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateUI];
}

- (void) setCorp:(TCCorp*)corp
{
    _nameLabel.text = corp.company_name;
    _applyTimeLabel.text = corp.create_time;
    _reviewTimeLabel.text = corp.update_time;
    if (corp.status == 1)
    {
        _statusLabel.text = @"审核通过";
    }else if(corp.status == -1)
    {
        _statusLabel.text = @"审核拒绝";
    }else
    {
        _statusLabel.text = @"审核中";
    }
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
@end
