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
@property (nonatomic, strong)           UIButton            *confirmButton;
@property (nonatomic, weak) IBOutlet    UITextField         *textField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (void) onConfirmButton:(id)sender;
- (void) updateConfirmButtonWithString:(NSString*)string;
@end

@implementation TCModifyTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    self.title = _titleText;
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.titleLabel.font = TCFont(15);
    [_confirmButton sizeToFit];
    UIBarButtonItem *reviewButton = [[UIBarButtonItem alloc] initWithCustomView:_confirmButton];
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
    
    [self updateConfirmButtonWithString:_textField.text];
    
    
    UIButton *clearButton = [self.textField valueForKey:@"_clearButton"];
    if (clearButton)
    {
        UIImage *delImg = [UIImage imageNamed:@"checkbox_circle"];
        //[UIImage imageNamed:@"edit_btn_del"];
        NSLog(@"dele img:%@",delImg);
        [clearButton setImage:delImg forState:UIControlStateNormal];
        [clearButton setImage:delImg forState:UIControlStateHighlighted];
        //[clearButton setTintColor:[UIColor redColor]];
        //[clearButton setBackgroundColor:[UIColor redColor]];
    }
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

- (void) updateConfirmButtonWithString:(NSString*)string
{
    if (string && string.length > 0)
    {
        if (![string isEqualToString:self.initialValue])
        {
            [_confirmButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
            [_confirmButton setUserInteractionEnabled:YES];
            return;
        }
    }
    UIColor *lightColor = [THEME_NAVBAR_TITLE_COLOR colorWithAlphaComponent:0.2];
    [_confirmButton setTitleColor:lightColor forState:UIControlStateNormal];
    [_confirmButton setUserInteractionEnabled:NO];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self onConfirmButton:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateConfirmButtonWithString:newString];
    return YES;
}

@end
