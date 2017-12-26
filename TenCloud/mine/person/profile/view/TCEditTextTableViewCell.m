//
//  TCEditTextTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditTextTableViewCell.h"
#import "TCModifyTextViewController.h"
#import "TCEditCellData.h"

@interface TCEditTextTableViewCell()
- (IBAction) onButton:(id)sender;
@end

@implementation TCEditTextTableViewCell

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
    self.descLabel.text = data.initialValue;
}

- (IBAction) onButton:(id)sender
{
    TCModifyTextViewController *modifyVC = [TCModifyTextViewController new];
    modifyVC.titleText = self.data.editPageTitle;
    modifyVC.initialValue = self.data.initialValue;
    modifyVC.keyName = self.data.keyName;
    __weak __typeof(self) weakSelf = self;
    modifyVC.valueChangedBlock = ^(TCModifyTextViewController *vc, id newValue) {
        weakSelf.data.initialValue = newValue;
        weakSelf.descLabel.text = newValue;
    };
    [self.fatherViewController.navigationController pushViewController:modifyVC animated:YES];
}

@end
