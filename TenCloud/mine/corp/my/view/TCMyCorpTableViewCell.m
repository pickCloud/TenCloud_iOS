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
    NSRange dateRange = NSMakeRange(0, 11);
    if (corp.create_time && corp.create_time.length > 0)
    {
        NSString *createDate = [corp.create_time substringWithRange:dateRange];
        //NSString *createDateStr = [NSString stringWithFormat:@"创建时间 %@",createDate];
        NSString *createDateStr = [NSString stringWithFormat:@"创建时间  %@",createDate];
        _applyTimeLabel.text = createDateStr;
    }
    if (corp.update_time && corp.update_time.length > 0)
    {
        NSString *reviewDate = [corp.update_time substringWithRange:dateRange];
        NSString *reviewDateStr = [NSString stringWithFormat:@"审核时间  %@",reviewDate];
        _reviewTimeLabel.text = reviewDateStr;
    }
    //_applyTimeLabel.text = corp.create_time;
    //_reviewTimeLabel.text = corp.update_time;
    
    if (corp.status == 1)
    {
        _statusLabel.text = @"审核通过";
        _statusLabel.textColor = STATE_PASS_COLOR;
    }else if(corp.status == -1)
    {
        _statusLabel.text = @"未通过审核";
        _statusLabel.textColor = STATE_ERROR_COLOR;
    }else if(corp.status == 0)
    {
        _statusLabel.text = @"审核中";
        _statusLabel.textColor = THEME_TINT_COLOR;
    }else
    {
        _statusLabel.text = @"初创建";
        _statusLabel.textColor = THEME_TINT_COLOR;
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
