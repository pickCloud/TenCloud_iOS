//
//  TCTextTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCTextTableViewCell.h"
#import "TCCellData.h"

@interface TCTextTableViewCell()

@end

@implementation TCTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(TCCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    NSString *descText = data.initialValue;
    if (descText == nil || descText.length == 0)
    {
        descText = @"未设置";
    }
    self.descLabel.text = descText;//data.initialValue;
    [self.detailView setHidden:data.hideDetailView];
}

@end
