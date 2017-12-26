//
//  TCModifyTextViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyTextViewController.h"
#import "TCModifyUserProfileRequest.h"


@interface TCModifyTextViewController ()<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *textField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (void) onConfirmButton:(id)sender;
@end

@implementation TCModifyTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    self.title = _titleText;
    
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textButton setTitle:@"确定" forState:UIControlStateNormal];
    [textButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [textButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    textButton.titleLabel.font = TCFont(15);
    [textButton sizeToFit];
    UIBarButtonItem *reviewButton = [[UIBarButtonItem alloc] initWithCustomView:textButton];
    self.navigationItem.rightBarButtonItem = reviewButton;
    
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入名称"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _textField.attributedPlaceholder = phonePlaceHolderStr;
    _textField.text = _initialValue;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    [_textField resignFirstResponder];
}

- (void) onConfirmButton:(id)sender
{
    [_textField resignFirstResponder];
    NSString *newValue = _textField.text;
    newValue = newValue ? newValue : @"";
    __weak __typeof(self) weakSelf = self;
    TCModifyUserProfileRequest *request = [[TCModifyUserProfileRequest alloc] initWithKey:_keyName value:newValue];
    [request startWithSuccess:^(NSString *message) {
        if (weakSelf.valueChangedBlock)
        {
            weakSelf.valueChangedBlock(weakSelf, newValue);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
    }];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self onConfirmButton:nil];
    return YES;
}
@end
