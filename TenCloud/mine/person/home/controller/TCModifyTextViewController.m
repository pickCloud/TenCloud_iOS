//
//  TCModifyTextViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyTextViewController.h"
#import "TCModifyUserProfileRequest.h"
#import "TCModifyCorpProfileRequest.h"
#import "TCCurrentCorp.h"
#import "NSString+Addition.h"


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
    
    NSString *placeHolder = _placeHolder;
    if (placeHolder == nil || placeHolder.length == 0)
    {
        placeHolder = @"请输入名称";
    }
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:placeHolder   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
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

- (void) modifyRequestResult:(BOOL)isSuccess message:(NSString*)msg
{
    if (isSuccess)
    {
        if (_valueChangedBlock)
        {
            NSString *newValue = _textField.text;
            newValue = newValue ? newValue : @"";
            _valueChangedBlock(self, newValue);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [MBProgressHUD showError:msg toView:nil];
    }
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
    
    if (_cellType == TCCellTypeEditEmail)
    {
        if (![newValue isEmailWithString:newValue])
        {
            [MBProgressHUD showError:@"邮箱格式不正确" toView:nil];
            return;
        }
    }
    
    if ([newValue isEqualToString:self.initialValue])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_requestBlock)
    {
        _requestBlock(self, newValue);
        return;
    }
    
    if (_apiType == TCApiTypeUpdateCorp)
    {
        TCModifyCorpProfileRequest *request = [[TCModifyCorpProfileRequest alloc] initWithCid:_cid key:_keyName value:newValue];
        [request startWithSuccess:^(NSString *message) {
            if ([_keyName isEqualToString:@"name"])
            {
                [[TCCurrentCorp shared] setName:newValue];
            }else if([_keyName isEqualToString:@"contact"])
            {
                [[TCCurrentCorp shared] setContact:newValue];
            }else if([_keyName isEqualToString:@"mobile"])
            {
                [[TCCurrentCorp shared] setMobile:newValue];
            }
            [[TCCurrentCorp shared] modified];
            
            if (weakSelf.valueChangedBlock)
            {
                weakSelf.valueChangedBlock(weakSelf, newValue);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }else
    {
        TCModifyUserProfileRequest *request = [[TCModifyUserProfileRequest alloc] initWithKey:_keyName value:newValue];
        [request startWithSuccess:^(NSString *message) {
            if ([_keyName isEqualToString:@"name"])
            {
                [[TCLocalAccount shared] setName:newValue];
                [[TCLocalAccount shared] save];
                [[TCLocalAccount shared] modified];
            }
            if ([_keyName isEqualToString:@"email"])
            {
                [[TCLocalAccount shared] setEmail:newValue];
                [[TCLocalAccount shared] save];
            }
            if (weakSelf.valueChangedBlock)
            {
                weakSelf.valueChangedBlock(weakSelf, newValue);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self onConfirmButton:nil];
    return YES;
}

@end
