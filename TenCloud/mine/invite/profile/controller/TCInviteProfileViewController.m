//
//  TCInviteProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCInviteProfileViewController.h"
#import "TCUser+CoreDataClass.h"
#import "TCInviteInfo+CoreDataClass.h"
#import "TCInviteSuccessViewController.h"
#import "TCCompleteInviteRequest.h"
#import "TCSetPasswordRequest.h"


@interface TCInviteProfileViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)           NSString            *code;
@property (nonatomic, strong)           NSString            *joinSetting;
@property (nonatomic, assign)           BOOL                shouldSetPassword;
@property (nonatomic, strong)           NSString            *phoneNumber;
@property (nonatomic, weak) IBOutlet    UITextField         *phoneNumField;
@property (nonatomic, weak) IBOutlet    UIView              *password1Panel;
@property (nonatomic, weak) IBOutlet    UIView              *password2Panel;
@property (nonatomic, weak) IBOutlet    UITextField         *password1Field;
@property (nonatomic, weak) IBOutlet    UITextField         *password2Field;
@property (nonatomic, weak) IBOutlet    UITextField         *nameField;
@property (nonatomic, weak) IBOutlet    UIView              *idCardPanel;
@property (nonatomic, weak) IBOutlet    UITextField         *idCardField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *widthConstraint;
@property (nonatomic, strong)   TCInviteInfo                *inviteInfo;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onConfirmJoinButton:(id)sender;
- (void) sendCompleteInviteRequest;
- (BOOL) isIDCardNeeded;
@end

@implementation TCInviteProfileViewController

- (instancetype) initWithCode:(NSString*)code
                  joinSetting:(NSString*)setting
            shouldSetPassword:(BOOL)setPassword
                  phoneNumber:(NSString *)phoneNumStr
{
    self = [super init];
    if (self)
    {
        _code = code;
        _joinSetting = setting;
        _shouldSetPassword = setPassword;
        _phoneNumber = phoneNumStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善资料";
    //_row3Label.font = TCFont(14);
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+25;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _widthConstraint.constant = screenRect.size.width;
    
    _phoneNumField.text = _phoneNumber;
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _password1Field.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *captchaPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请再次输入密码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _password2Field.attributedPlaceholder = captchaPlaceHolderStr;
    NSAttributedString *namePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入真实姓名"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _nameField.attributedPlaceholder = namePlaceHolderStr;
    NSAttributedString *idCardPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入身份证号"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _idCardField.attributedPlaceholder = idCardPlaceHolderStr;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    if (!_shouldSetPassword)
    {
        [_password1Panel setHidden:YES];
        [_password2Panel setHidden:YES];
        _widthConstraint.constant = 0;
    }
    
    BOOL hideIDCardPanel = ![self isIDCardNeeded];
    [_idCardPanel setHidden:hideIDCardPanel];
    
    if ([[TCLocalAccount shared] isNameSetted])
    {
        _nameField.text = [[TCLocalAccount shared] name];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    NSLog(@"on tap blank area");
    [_password1Field resignFirstResponder];
    [_password2Field resignFirstResponder];
    [_nameField resignFirstResponder];
    [_idCardField resignFirstResponder];
}

- (IBAction) onConfirmJoinButton:(id)sender
{
    NSLog(@"on register button");
    if (_shouldSetPassword)
    {
        NSString *pwd1 = _password1Field.text;
        NSString *pwd2 = _password2Field.text;
        if (!pwd1 || pwd1.length == 0)
        {
            [MBProgressHUD showError:@"请输入密码" toView:nil];
            return;
        }
        if (!pwd2 || pwd2.length == 0)
        {
            [MBProgressHUD showError:@"请再次输入密码" toView:nil];
            return;
        }
        if (![pwd1 isEqualToString:pwd2])
        {
            [MBProgressHUD showError:@"密码不一致" toView:nil];
            return;
        }
    }
    
    NSString *name = _nameField.text;
    if (!name || name.length == 0)
    {
        [MBProgressHUD showError:@"请输入姓名" toView:nil];
        return;
    }
    
    NSString *idCardStr = _idCardField.text;
    if ([self isIDCardNeeded])
    {
        if (!idCardStr || idCardStr.length == 0)
        {
            [MBProgressHUD showError:@"请输入身份证号" toView:nil];
            return;
        }
    }

    [_password1Field resignFirstResponder];
    [_password2Field resignFirstResponder];
    [_nameField resignFirstResponder];
    [_idCardField resignFirstResponder];
    
    [MMProgressHUD showWithStatus:@"提交中"];
    if (_shouldSetPassword)
    {
        __weak __typeof(self) weakSelf = self;
        TCSetPasswordRequest *pwdReq = [[TCSetPasswordRequest alloc] initWithPassword:_password1Field.text];
        [pwdReq startWithSuccess:^(NSString *message) {
            [weakSelf sendCompleteInviteRequest];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }else
    {
        [self sendCompleteInviteRequest];
    }
}

- (void) sendCompleteInviteRequest
{
    __weak __typeof(self) weakSelf = self;
    TCCompleteInviteRequest *req = [TCCompleteInviteRequest new];
    req.code = _code;
    req.mobile = _phoneNumber;
    req.name = _nameField.text;
    req.idCard = _idCardField.text;
    [req startWithSuccess:^(NSString *message) {
        [MMProgressHUD dismissWithoutAnimation];
        [[TCLocalAccount shared] setName:weakSelf.nameField.text];
        [[TCLocalAccount shared] save];
        TCInviteSuccessViewController *successVC = [[TCInviteSuccessViewController alloc] initWithTitle:@"提交成功" desc:@"申请已提交，待管理员审核通过，即可加入企业"];
        [weakSelf.navigationController pushViewController:successVC animated:YES];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message afterDelay:1.32];
    }];
}

- (BOOL) isIDCardNeeded
{
    return NO;
    if (_joinSetting && _joinSetting.length > 0)
    {
        NSArray *settingArray = [_joinSetting componentsSeparatedByString:@","];
        if ([settingArray containsObject:@"id_card"])
        {
            return YES;
        }
    }
    return NO;
}

@end
