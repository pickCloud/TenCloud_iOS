//
//  TCRegisterViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCRegisterViewController.h"

@interface TCRegisterViewController ()
@property (nonatomic, weak) IBOutlet    UITextField     *phoneNumberField;
@property (nonatomic, weak) IBOutlet    UITextField     *captchaField;
@property (nonatomic, weak) IBOutlet    UITextField     *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField     *password2Field;
@end

@implementation TCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入手机号码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _phoneNumberField.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *captchaPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入验证码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _captchaField.attributedPlaceholder = captchaPlaceHolderStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
