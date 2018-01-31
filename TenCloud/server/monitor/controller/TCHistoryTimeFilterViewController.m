//
//  TCHistoryTimeFilterViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCHistoryTimeFilterViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "TCMonitorHistoryTime.h"

@interface TCHistoryTimeFilterViewController ()
@property (nonatomic, weak) IBOutlet    UIView      *darkBackgroundView;
@property (nonatomic, weak) IBOutlet    UIView      *contentView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *contentViewTrailingConstraint;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UIButton            *startButton;
@property (nonatomic, weak) IBOutlet    UIButton            *endButton;
@property (nonatomic, assign)           BOOL                isStartTime;
- (IBAction) onConfirmButton:(id)sender;
- (IBAction) onStartTimeButton:(id)sender;
- (IBAction) onEndTimeButton:(id)sender;
- (void) dismiss;
@end

@implementation TCHistoryTimeFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.darkBackgroundView.alpha = 0.0;
    self.contentViewTrailingConstraint.constant = - kScreenWidth;
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 40 + 20;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.darkBackgroundView addGestureRecognizer:tapGesture];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.darkBackgroundView addGestureRecognizer:swipeGesture];
    
    TCMonitorHistoryTime *historyTime = [TCMonitorHistoryTime shared];
    if (historyTime.startTime > 0)
    {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:historyTime.startTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"   yyyy年MM月dd日 hh:mm:ss"];
        NSString *startDateStr = [dateFormatter stringFromDate:startDate];
        [_startButton setTitle:startDateStr forState:UIControlStateNormal];
    }
    if (historyTime.endTime > 0)
    {
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:historyTime.endTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"   yyyy年MM月dd日 hh:mm:ss"];
        NSString *endDateStr = [dateFormatter stringFromDate:endDate];
        [_endButton setTitle:endDateStr forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - extension
- (IBAction) onConfirmButton:(id)sender
{
    NSLog(@"on confirm button");
    if (_valueChangedBlock)
    {
        _valueChangedBlock(self);
    }
    [self dismiss];
}

- (IBAction) onStartTimeButton:(id)sender
{
    NSLog(@"on start time button");
    _isStartTime = YES;
    NSDate *startDate = [NSDate date];
    NSInteger startTimeInt = [[TCMonitorHistoryTime shared] startTime];
    if (startTimeInt > 0)
    {
        startDate = [NSDate dateWithTimeIntervalSince1970:startTimeInt];
    }
    ActionSheetDatePicker *picker = [ActionSheetDatePicker alloc];
    picker = [picker initWithTitle:@"选择开始时间"
                    datePickerMode:UIDatePickerModeDateAndTime
                      selectedDate:startDate
                            target:self
                            action:@selector(actionSheetPickerSelectDate:element:)
                            origin:self.view];
    
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

- (IBAction) onEndTimeButton:(id)sender
{
    NSLog(@"on end time button");
    _isStartTime = NO;
    
    NSDate *startDate = [NSDate date];
    NSInteger startTimeInt = [[TCMonitorHistoryTime shared] startTime];
    if (startTimeInt > 0)
    {
        startDate = [NSDate dateWithTimeIntervalSince1970:startTimeInt];
    }
    NSDate *endDate = [NSDate date];
    NSInteger endTimeInt = [[TCMonitorHistoryTime shared] endTime];
    if (endTimeInt > 0)
    {
        endDate = [NSDate dateWithTimeIntervalSince1970:endTimeInt];
    }
    ActionSheetDatePicker *picker = [ActionSheetDatePicker alloc];
    picker = [picker initWithTitle:@"选择结束时间"
                    datePickerMode:UIDatePickerModeDateAndTime
                      selectedDate:endDate
                            target:self
                            action:@selector(actionSheetPickerSelectDate:element:)
                            origin:self.view];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1910];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    if (startTimeInt > 0)
    {
        minDate = startDate;
    }
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

- (void) dismiss
{
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        weakSelf.contentViewTrailingConstraint.constant = -_contentView.frame.size.width;
        weakSelf.darkBackgroundView.alpha = 0.0;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void) showContentView
{
    self.contentViewTrailingConstraint.constant = - _contentView.frame.size.width;
    
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0.01 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        weakSelf.darkBackgroundView.alpha = 1.0;
        
        weakSelf.contentViewTrailingConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    } completion:NULL];
    
}

- (void) onTapGesture:(id)sender
{
    [self dismiss];
}

- (void) actionSheetPickerSelectDate:(NSDate*)date element:(id)element
{
    NSLog(@"element:%@",element);
    __weak __typeof(self) weakSelf = self;
    NSNumber *timeStamp = @(date.timeIntervalSince1970);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"   yyyy年MM月dd日 hh:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"start dateStr:%@",dateStr);
    //weakSelf.descLabel.text = dateStr;
    if (_isStartTime)
    {
        [[TCMonitorHistoryTime shared] setStartTime:timeStamp.integerValue];
        [_startButton setTitle:dateStr forState:UIControlStateNormal];
    }else
    {
        [[TCMonitorHistoryTime shared] setEndTime:timeStamp.integerValue];
        [_endButton setTitle:dateStr forState:UIControlStateNormal];
    }
}

@end
