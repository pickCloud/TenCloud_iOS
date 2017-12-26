//
//  TCEditGenderTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditGenderTableViewCell.h"
#import "TCCellData.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "TCModifyUserProfileRequest.h"

@interface TCEditGenderTableViewCell()
- (IBAction) onButton:(id)sender;
- (void) updateGenderLabel;
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

- (void) setData:(TCCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    [self updateGenderLabel];
}

- (void) updateGenderLabel
{
    NSNumber *genderNum = self.data.initialValue;
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
    __weak __typeof(self) weakSelf = self;
    NSInteger selection = 0;
    NSNumber *genderNum = self.data.initialValue;
    if (genderNum.integerValue == 2) 
    {
        selection = 1;
    }
    ActionSheetStringPicker *picker = [ActionSheetStringPicker alloc];
    NSArray *options = @[@"男",@"女"];
    picker = [picker initWithTitle:@"选择性别"
                     rows:options
         initialSelection:selection
                doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    NSNumber *gender = [NSNumber numberWithInteger:selectedIndex+1];
                    [MMProgressHUD showWithStatus:@"修改性别中"];
                    TCModifyUserProfileRequest *req = [[TCModifyUserProfileRequest alloc] initWithKey:@"gender" value:gender];
                    [req startWithSuccess:^(NSString *message) {
                        [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
                        TCLocalAccount *account = [TCLocalAccount shared];
                        account.gender = gender.integerValue;
                        [account save];
                        [account modified];
                        weakSelf.data.initialValue = gender;
                        [weakSelf updateGenderLabel];
                    } failure:^(NSString *message) {
                        [MMProgressHUD dismissWithError:message];
                    }];
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self];
    
    UIButton *okButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitle:@"确定" forState:UIControlStateHighlighted];
    okButton.titleLabel.font = TCFont(PICKER_BUTTON_FONT_SIZE);
    [okButton setTitleColor:THEME_TINT_COLOR forState:UIControlStateNormal];
    [okButton setTitleColor:THEME_TINT_COLOR forState:UIControlStateHighlighted];
    
    [okButton setFrame:CGRectMake(0, 0, 32, 32)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:okButton]];
    
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = TCFont(PICKER_BUTTON_FONT_SIZE);
    
    [cancelButton setTitleColor:THEME_TINT_COLOR forState:UIControlStateNormal];
    [cancelButton setTitleColor:THEME_TINT_COLOR forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 32, 32)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    [picker setTapDismissAction:TapActionCancel];
    [picker showActionSheetPicker];
}

@end
