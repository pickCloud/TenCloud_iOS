//
//  TCBindRepoTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCBindRepoTableViewCell.h"
#import "TCGitRepo.h"

@interface TCBindRepoTableViewCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *addressLabel;
@property (nonatomic, weak) IBOutlet    UIImageView *selectedView;
@end

@implementation TCBindRepoTableViewCell

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

- (void) setRepo:(TCGitRepo*)repo
{
    _nameLabel.text = repo.name;
    NSString *addr = [NSString stringWithFormat:@"路径: %@",repo.address];
    if (repo.address.length == 0)
    {
        addr = @"";
    }
    _addressLabel.text = addr;
}

@end
