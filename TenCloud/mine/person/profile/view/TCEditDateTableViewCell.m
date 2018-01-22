//
//  TCEditDateTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditDateTableViewCell.h"
#import "TCCellData.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "TCModifyUserProfileRequest.h"
#import "NSString+Extension.h"

@interface TCEditDateTableViewCell()
- (IBAction) onButton:(id)sender;
- (void) updateDateLabel;
@end

@implementation TCEditDateTableViewCell

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
    [self updateDateLabel];
    if (self.data.editable)
    {
        [self.detailView setHidden:NO];
    }else
    {
        [self.detailView setHidden:YES];
    }
}

- (void) updateDateLabel
{
    NSNumber *dateNum = self.data.initialValue;
    if (dateNum.integerValue <= 0)
    {
        self.descLabel.text = @"未设置";
    }else
    {
        NSString *dateStr = [NSString dateStringFromTimeInterval:dateNum.integerValue];
        self.descLabel.text = dateStr;
    }
}

- (IBAction) onButton:(id)sender
{
    if (!self.data.editable)
    {
        return;
    }
    NSNumber *dateNum = self.data.initialValue;
    NSDate *birthDate = nil;
    if (dateNum.integerValue <= 0)
    {
        birthDate = [NSDate date];
    }else
    {
        birthDate = [NSDate dateWithTimeIntervalSince1970:dateNum.integerValue];
    }

    ActionSheetDatePicker *picker = [ActionSheetDatePicker alloc];
    picker = [picker initWithTitle:@"设置出生日期"
                    datePickerMode:UIDatePickerModeDate
                      selectedDate:birthDate
                            target:self
                            action:@selector(actionSheetPickerSelectDate:element:)
                            origin:self];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1910];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    [(ActionSheetDatePicker*)picker setMinimumDate:minDate];
    [(ActionSheetDatePicker*)picker setMaximumDate:maxDate];
    
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
              
- (void) actionSheetPickerSelectDate:(NSDate*)date element:(id)element
{
    __weak __typeof(self) weakSelf = self;
    NSNumber *timeStamp = @(date.timeIntervalSince1970);
    TCModifyUserProfileRequest *req = [[TCModifyUserProfileRequest alloc] initWithKey:@"birthday"
                                                                                value:timeStamp];
    [req startWithSuccess:^(NSString *message) {
        TCLocalAccount *account = [TCLocalAccount shared];
        account.birthday = date.timeIntervalSince1970;
        [account save];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        weakSelf.descLabel.text = dateStr;
    } failure:^(NSString *message) {
        
    }];

}

@end
