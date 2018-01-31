//
//  TCInviteLoginViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCInviteLoginViewController.h"
#import "GetCaptchaButton.h"
#import "TCSpacingTextField.h"
#import "TCGetCaptchaRequest.h"
#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
#import "TCTabBarController.h"
#import "TCResetPasswordRequest.h"
#import <GT3Captcha/GT3Captcha.h>
#import "TCGeetestCaptchaRequest.h"
#import "TCInviteInfoRequest.h"
#import "TCInviteInfo+CoreDataClass.h"
#import "TCCaptchaLoginRequest.h"
#import "TCInviteProfileViewController.h"
#import "TCAcceptInviteRequest.h"
#import "TCStaffStatusRequest.h"
#import "TCInviteJoinedViewController.h"



@interface TCInviteLoginViewController ()<UIGestureRecognizerDelegate,GT3CaptchaManagerDelegate>
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneNumberField;
@property (nonatomic, weak) IBOutlet    UITextField         *captchaField;
@property (nonatomic, weak) IBOutlet    GetCaptchaButton    *captchaButton;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, strong)           NSString            *code;
@property (nonatomic, strong)           GT3CaptchaButton    *gt3Button;
@property (nonatomic, weak) IBOutlet    UILabel             *row1Label;
@property (nonatomic, weak) IBOutlet    UILabel             *row2Label;
@property (nonatomic, weak) IBOutlet    UILabel             *row3Label;
@property (nonatomic, weak) IBOutlet    UIButton            *inviteButton;
@property (nonatomic, weak) IBOutlet    UIView              *phonePanel;
@property (nonatomic, weak) IBOutlet    UIView              *captchaPanel;
@property (nonatomic, strong)   TCInviteInfo                *inviteInfo;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onGetCaptchaButton:(id)sender;
- (IBAction) onConfirmJoinButton:(id)sender;
- (void) updateInviteInfoUI;
- (void) loginWithToken:(NSString*)token shouldSetPassword:(BOOL)shouldSet;
@end

@implementation TCInviteLoginViewController

- (instancetype) initWithCode:(NSString*)code
{
    self = [super init];
    if (self)
    {
        _code = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请员工";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    _row3Label.font = TCFont(14);
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+25;
    }
    
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入手机号码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _phoneNumberField.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *captchaPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入验证码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _captchaField.attributedPlaceholder = captchaPlaceHolderStr;
    
    _phoneNumberField.firstSpacingPosition = 3;
    _phoneNumberField.secondSpacingPosition = 8;
    _phoneNumberField.maxLength = 11;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:GEETEST_API1 API2:GEETEST_API2 timeout:8.0];
    captchaManager.delegate = self;
    UIColor *maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    captchaManager.maskColor = maskColor;
    _gt3Button = [[GT3CaptchaButton alloc] initWithFrame:CGRectZero captchaManager:captchaManager];
    [_gt3Button startCaptcha];
    [self.view addSubview:self.gt3Button];
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCInviteInfoRequest *req = [[TCInviteInfoRequest alloc] initWithCode:_code];
    [req startWithSuccess:^(TCInviteInfo *info) {
        NSLog(@"info_comp:%@",info.company_name);
        NSLog(@"info_contact:%@",info.contact);
        NSLog(@"info_setting:%@",info.setting);
        weakSelf.inviteInfo = info;
        [weakSelf updateInviteInfoUI];
        [weakSelf stopLoading];
    } failure:^(NSString *message) {
        NSLog(@"info_msg:%@",message);
        [weakSelf stopLoading];
        [weakSelf updateInviteInfoUI];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    NSLog(@"on tap blank area");
    [_phoneNumberField resignFirstResponder];
    [_captchaField resignFirstResponder];
}

- (IBAction) onGetCaptchaButton:(id)sender
{
    NSLog(@"on get captcha button");
    if (_phoneNumberField.plainPhoneNum.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号" toView:nil];
        return;
    }
    [_captchaField becomeFirstResponder];
    
    if (_captchaButton.fetchState == FetchCaptchaStateNone ||
        _captchaButton.fetchState == FetchCaptchaStateRefetch)
    {
        [_captchaButton setFetchState:FetchCaptchaStateCountdown];
        TCGetCaptchaRequest *request = [[TCGetCaptchaRequest alloc] initWithPhoneNumber:_phoneNumberField.plainPhoneNum];
        __weak __typeof(self) weakSelf = self;
        [request startWithSuccess:^(NSString *message) {
            [MBProgressHUD showSuccess:@"短信验证码已发送，请注意查收" toView:nil];
            [weakSelf.captchaField becomeFirstResponder];
        } failure:^(NSString *message, NSInteger errorCode) {
            if (errorCode == 10405)
            {
                [weakSelf.captchaField resignFirstResponder];
                [weakSelf.gt3Button startCaptcha];
            }else
            {
                [MBProgressHUD showError:message toView:nil];
            }
        }];
    }
}

- (IBAction) onConfirmJoinButton:(id)sender
{
    NSLog(@"on register button");
    if ([self isInviteInfoInvalid])
    {
        return;
    }
    NSString *phoneNumStr = _phoneNumberField.plainPhoneNum;
    if (phoneNumStr.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号" toView:nil];
        return;
    }
    if (_captchaField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入验证码" toView:nil];
        return;
    }
    
    [_phoneNumberField resignFirstResponder];
    [_captchaField resignFirstResponder];
    
    __weak __typeof(self) weakSelf = self;
    [MMProgressHUD showWithStatus:@"加入中"];
    TCCaptchaLoginRequest *loginReq = [[TCCaptchaLoginRequest alloc] initWithPhoneNumber:phoneNumStr captcha:_captchaField.text];
    [loginReq startWithSuccess:^(NSString *token) {
        [weakSelf loginWithToken:token shouldSetPassword:NO];
    } failure:^(NSString *message, NSInteger errorCode) {
        if (errorCode == 10404)
        {
            NSString *token = message;
            [weakSelf loginWithToken:token shouldSetPassword:YES];
            /*
            [[TCLocalAccount shared] setToken:token];
            TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
            [request startWithSuccess:^(TCUser *user) {
                NSLog(@"user:%@",user);
                user.token = token;
                [[TCLocalAccount shared] loginSuccess:user];
                [MMProgressHUD dismiss];
                
                TCInviteProfileViewController *profileVC = [[TCInviteProfileViewController alloc] initWithCode:_code joinSetting:_inviteInfo.setting shouldSetPassword:YES phoneNumber:user.mobile];
                [self.navigationController pushViewController:profileVC animated:YES];
            } failure:^(NSString *message) {
                NSLog(@"msg:%@",message);
                [MMProgressHUD dismissWithError:message];
            }];
            */
        }else
        {
            [MMProgressHUD dismissWithError:message];
        }
    }];
    /*
    [MMProgressHUD showWithStatus:@"找回密码中"];
    TCResetPasswordRequest *request = [[TCResetPasswordRequest alloc] initWithPhoneNumber:_phoneNumberField.plainPhoneNum password:_passwordField.text captcha:_captchaField.text];
    [request startWithSuccess:^(NSString *token) {
        [[TCLocalAccount shared] setToken:token];
        TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
        [request startWithSuccess:^(TCUser *user) {
            user.token = token;
            [[TCLocalAccount shared] loginSuccess:user];
            TCTabBarController *tabBarController = [TCTabBarController new];
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
            [MMProgressHUD dismissWithSuccess:@"成功找回密码" title:nil afterDelay:1.32];
        } failure:^(NSString *message) {
            NSLog(@"msg:%@",message);
            [MMProgressHUD dismissWithError:@"找回失败"];
        }];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
     */
}

- (BOOL) isInviteInfoInvalid
{
    BOOL isValid = _inviteInfo.company_name == nil ||
    _inviteInfo.company_name.length == 0 ||
    _inviteInfo.contact == nil ||
    _inviteInfo.contact.length == 0;
    return isValid;
}

- (void) updateInviteInfoUI
{
    if ([self isInviteInfoInvalid])
    {
        _row1Label.text = @"邀请链接已过期，请联系管理员重新邀请";
        _row2Label.text = @"";
        _row3Label.text = @"";
        _phonePanel.hidden = YES;
        _captchaPanel.hidden = YES;
        _inviteButton.alpha = 0.2;
        return;
    }
    CGRect row1Rect = _row1Label.frame;
    NSLog(@"row1Rect:%.2f, %.2f, %.2f, %.2f",row1Rect.origin.x, row1Rect.origin.y, row1Rect.size.width,
          row1Rect.size.height);
    NSMutableAttributedString *row1Str = [NSMutableAttributedString new];
    UIFont *textFont = TCFont(14.0);
    NSDictionary *greenAttr = @{NSForegroundColorAttributeName : THEME_TINT_COLOR,
                                NSFontAttributeName : textFont };
    NSDictionary *grayAttr = @{NSForegroundColorAttributeName : THEME_TEXT_COLOR,
                                NSFontAttributeName : textFont };
    NSString *str1 = [NSString stringWithFormat:@"%@",_inviteInfo.contact];
    NSMutableAttributedString *tmp1 = nil;
    tmp1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:greenAttr];
    NSString *str2 = @" 邀请你加入企业 ";
    NSMutableAttributedString *tmp2 = nil;
    tmp2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:grayAttr];
    //[row1Str appendAttributedString:tmp1];
    CGSize boundSize = CGSizeMake(row1Rect.size.width, MAXFLOAT);
    CGRect rect1 = [str1 boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:greenAttr context:nil];
    CGRect rect2 = [str2 boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:grayAttr context:nil];
    NSString *str3 = _inviteInfo.company_name;
    NSMutableAttributedString *tmp3 = nil;
    tmp3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:greenAttr];
    /*
    CGRect rect3 = [str3 boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:greenAttr context:nil];
    CGFloat previeWidth = rect1.size.width + rect2.size.width +rect3.size.width;
    if (previeWidth <= row1Rect.size.width)
    {
        [row1Str appendAttributedString:tmp1];
        [row1Str appendAttributedString:tmp2];
        [row1Str appendAttributedString:tmp3];
        _row1Label.attributedText = row1Str;
        _row2Label.text = @"";
    }else
    {
        [row1Str appendAttributedString:tmp1];
        [row1Str appendAttributedString:tmp2];
        _row1Label.attributedText = row1Str;
        _row2Label.attributedText = tmp3;
    }
     */
    [row1Str appendAttributedString:tmp3];
    [row1Str appendAttributedString:tmp2];
    _row1Label.attributedText = row1Str;
    _row2Label.text = @"";
}

- (void) loginWithToken:(NSString*)token shouldSetPassword:(BOOL)shouldSet
{
    __weak __typeof(self) weakSelf = self;
    [[TCLocalAccount shared] setToken:token];
    TCUserProfileRequest *profileReq = [[TCUserProfileRequest alloc] init];
    [profileReq startWithSuccess:^(TCUser *user) {
        user.token = token;
        [[TCLocalAccount shared] loginSuccess:user];
        
        //获取员工在该公司状态
        TCStaffStatusRequest *statusReq = [[TCStaffStatusRequest alloc] initWithCorpID:weakSelf.inviteInfo.cid];
        [statusReq startWithSuccess:^(NSInteger status) {
            if (status == STAFF_STATUS_PENDING ||
                status == STAFF_STATUS_PASS)
            {
                [MMProgressHUD dismissWithoutAnimation];
                TCInviteJoinedViewController *joinedVC = [[TCInviteJoinedViewController alloc] initWithStaffStatus:status corpID:weakSelf.inviteInfo.cid];
                NSMutableArray *newVCS = [NSMutableArray array];
                [newVCS addObject:joinedVC];
                [self.navigationController setViewControllers:newVCS];
            }else
            {
                [weakSelf stopLoading];
                TCAcceptInviteRequest *acceptReq = [[TCAcceptInviteRequest alloc] initWithCode:_code];
                [acceptReq startWithSuccess:^(NSString *message) {
                    [MMProgressHUD dismissWithoutAnimation];
                    TCInviteProfileViewController *profileVC = [[TCInviteProfileViewController alloc] initWithCode:_code joinSetting:_inviteInfo.setting shouldSetPassword:shouldSet phoneNumber:user.mobile];
                    [weakSelf.navigationController pushViewController:profileVC animated:YES];
                } failure:^(NSString *message) {
                    [MMProgressHUD dismissWithError:message afterDelay:1.32];
                }];
            }
        } failure:^(NSString *message) {
            [MMProgressHUD dismissWithError:message afterDelay:1.32];
        }];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:@"加入失败，请稍后再试" afterDelay:1.32];
    }];
}

#pragma mark - GT3CaptchaManagerDelegate
- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
    }
    else if (error.code == -20) {
        // 尝试过多
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
    }
    [MBProgressHUD showError:error.localizedDescription toView:nil];
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy captchaPolicy))decisionHandler
{
    
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"User Did Close GTView.");
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    __weak __typeof(self) weakSelf = self;
    NSString *challenge = [result objectForKey:@"geetest_challenge"];
    NSString *seccode = [result objectForKey:@"geetest_seccode"];
    NSString *validate = [result objectForKey:@"geetest_validate"];
    NSString *phoneNum = _phoneNumberField.plainPhoneNum;
    TCGeetestCaptchaRequest *request = [[TCGeetestCaptchaRequest alloc] initWithPhoneNumber:phoneNum challenge:challenge validate:validate seccode:seccode];
    [request startWithSuccess:^(NSString *message) {
        [weakSelf.captchaButton setFetchState:FetchCaptchaStateCountdown];
        [MBProgressHUD showSuccess:@"验证码已发送，请查收" toView:nil];
    } failure:^(NSString *message, NSInteger errorCode) {
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    return NO;
}
@end
