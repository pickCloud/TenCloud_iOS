//
//  TCEditTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCBasicTableViewCell.h"

@implementation TCBasicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:29/255.0 green:32/255.0 blue:42/255.0 alpha:1];
    self.selectedBackgroundView = selectedBgView;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 */

@end
