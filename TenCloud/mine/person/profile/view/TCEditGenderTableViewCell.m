//
//  TCEditGenderTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditGenderTableViewCell.h"
#import "TCEditCellData.h"

@interface TCEditGenderTableViewCell()
- (IBAction) onButton:(id)sender;
@end

@implementation TCEditGenderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(TCEditCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    NSNumber *genderNum = data.initialValue;
    if (genderNum.integerValue == 1)
    {
        self.descLabel.text = @"男";
    }else if(genderNum.integerValue == 2)
    {
        self.descLabel.text = @"女";
    }else
    {
        self.descLabel.text = @"未设置";
    }
}

- (IBAction) onButton:(id)sender
{
    
}

@end
