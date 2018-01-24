//
//  TCAccountMenuTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAccountMenuTableViewCell.h"
#import "TCTagLabel.h"
#import "TCListCorp+CoreDataClass.h"

@interface TCAccountMenuTableViewCell ()
@property (nonatomic, weak) IBOutlet    TCTagLabel  *tagLabel2;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIImageView *tickView;
- (void) updateUI;
@end

@implementation TCAccountMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:29/255.0 green:32/255.0 blue:42/255.0 alpha:0];
    self.selectedBackgroundView = selectedBgView;
    

}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self updateUI];
}
 */


- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateUI];
}

/*
- (void) setName:(NSString *)name
{
    _nameLabel.text = name;
}
 */

- (void) setCorp:(TCListCorp*)corp
{
    _nameLabel.text = corp.company_name;
    if (corp.is_admin)
    {
        _tagLabel2.text = @"管理员";
    }else if(corp.cid == 0)
    {
        _tagLabel2.text = @"个人";
    }else
    {
        _tagLabel2.text = @"员工";
    }
    //[self updateUI];
}

- (void) updateUI
{
    if (self.selected)
    {
        _nameLabel.textColor = THEME_TINT_COLOR;
        _tickView.hidden = NO;
        self.tagLabel2.backgroundColor = THEME_TINT_COLOR;
    }else
    {
        _nameLabel.textColor = THEME_TEXT_COLOR;
        _tickView.hidden = YES;
        _tagLabel2.backgroundColor = THEME_TEXT_COLOR;
    }
}
@end
