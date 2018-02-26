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
@property (nonatomic, weak) TCListCorp  *corp;
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


- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        _tagLabel2.backgroundColor = THEME_TINT_COLOR;
        _nameLabel.textColor = THEME_TINT_COLOR;
        _tickView.hidden = NO;
    }else
    {
        [self updateUI];
    }
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

- (void) setCorp:(TCListCorp*)corp
{
    _corp = corp;
    /*
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
    [self updateUI];
     */
}

- (void) updateUI
{
    NSString *companyName = nil;
    if (_corp.company_name && _corp.company_name.length > 11)
    {
        NSRange preRange = NSMakeRange(0, 11);
        NSString *preStr = [_corp.company_name substringWithRange:preRange];
        companyName = [NSString stringWithFormat:@"%@...",preStr];
    }else
    {
        companyName = _corp.company_name;
    }
    _nameLabel.text = companyName;
    if (_corp.is_admin)
    {
        _tagLabel2.text = @"管理员";
    }else if(_corp.cid == 0)
    {
        _tagLabel2.text = @"个人";
    }else
    {
        _tagLabel2.text = @"员工";
    }
    if (self.selected)
    {
        //NSLog(@"tag selected:%@",_corp.company_name);
        _nameLabel.textColor = THEME_TINT_COLOR;
        _tickView.hidden = NO;
        //_tagLabel2.backgroundColor = THEME_TINT_COLOR;
    }else
    {
        //NSLog(@"tag not selected:%@",_corp.company_name);
        _nameLabel.textColor = THEME_TEXT_COLOR;
        _tickView.hidden = YES;
        //_tagLabel2.backgroundColor = THEME_TEXT_COLOR;
    }
    
    //NSString *currentName = [[TCCurrentCorp shared] name];
    //NSLog(@"current:%@ _corp:%@",currentName,_corp.company_name);
    BOOL selected = [[TCCurrentCorp shared] isSameWithID:_corp.cid name:_corp.company_name];
    //if ([currentName isEqualToString:_corp.company_name])
    if(selected)
    {
        _tagLabel2.backgroundColor = THEME_TINT_COLOR;
    }else
    {
        _tagLabel2.backgroundColor = THEME_TEXT_COLOR;
    }
}
@end
