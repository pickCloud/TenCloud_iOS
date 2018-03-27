//
//  TCAppSectionHeaderCell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/27.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAppSectionHeaderCell.h"

@interface TCAppSectionHeaderCell()
- (IBAction) onDetailButton:(id)sender;
@end

@implementation TCAppSectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) onDetailButton:(id)sender
{
    NSLog(@"on detail button");
}
@end
