//
//  TCLoginViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCLoginViewController.h"
#import "HMSegmentedControl.h"
#import "TCPasswordLoginRequest.h"
#import "TCTabBarController.h"
#import "TCSpacingTextField.h"
#import "GetCaptchaButton.h"
#import "TCGetCaptchaRequest.h"
#import "TCCaptchaLoginRequest.h"
#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
#import "TCRegisterViewController.h"
#import "TCForgetPasswordViewController.h"
#import "VHLNavigation.h"
#import "TCSetPasswordViewController.h"
#import "TCGetGeetestDataRequest.h"
#import "TCGeetestCaptchaRequest.h"

#import <GT3Captcha/GT3Captcha.h>
#define api_1   @"http://47.94.18.22:18080/api/user/captcha"
#define api_2   @"http://47.94.18.22:18080/api/user/sms"


@interface TCLoginViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,GT3CaptchaManagerDelegate>
@property (nonatomic, weak) IBOutlet    HMSegmentedControl  *segmentControl;
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneNumField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneNum2Field;
@property (nonatomic, weak) IBOutlet    UITextField         *captchaField;
@property (nonatomic, weak) IBOutlet    GetCaptchaButton    *captchaButton;
@property (nonatomic, weak) IBOutlet    UIScrollView        *scrollView;
@property (nonatomic, assign)   NSInteger                   currentPageIndex;

@property (nonatomic, strong)   GT3CaptchaButton            *gt3Button;
- (void) loadPageAtIndex:(NSInteger)pageIndex;
- (void) onTapBlankArea:(id)sender;
- (void) loginSuccessWithToken:(NSString *)token;
- (IBAction) onLoginButton:(id)sender;
- (IBAction) onGetCaptcha:(id)sender;
- (IBAction) onRegisterButton:(id)sender;
- (IBAction) onForgetPasswordButton:(id)sender;
@end

@implementation TCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self vhl_setNavBarHidden:YES];
    [self vhl_setNavBarTintColor:THEME_TINT_COLOR];
    
    // Do any additional setup after loading the view from its nib.
    NSMutableArray  *segmentTitles = [NSMutableArray new];
    [segmentTitles addObject:@"密码登录"];
    [segmentTitles addObject:@"验证码登录"];
    [_segmentControl setSectionTitles:segmentTitles];
    __weak  __typeof(self) weakSelf = self;
    [_segmentControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"select segment %ld",index);
        [weakSelf loadPageAtIndex:index];
    }];
    _segmentControl.selectionIndicatorHeight = 2.0f;
    _segmentControl.backgroundColor = [UIColor clearColor];
    UIFont *titleFont = [UIFont systemFontOfSize:TCSCALE(14.0)];
    _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : THEME_TEXT_COLOR,
                                            NSFontAttributeName : titleFont };
    UIFont *selectedFont = [UIFont boldSystemFontOfSize:TCSCALE(14)];
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : THEME_TINT_COLOR, NSFontAttributeName : selectedFont };
    _segmentControl.selectionIndicatorColor = THEME_TINT_COLOR;
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.shouldAnimateUserSelection = YES;
    //_segmentControl.userInteractionEnabled = YES;
    
    UIColor *placeHolderColor = THEME_PLACEHOLDER_COLOR2;
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"手机号"   attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
    _phoneNumField.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *pwdPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"密码"   attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
    _passwordField.attributedPlaceholder = pwdPlaceHolderStr;
    _phoneNum2Field.attributedPlaceholder = phonePlaceHolderStr;
    NSAttributedString *captchaPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"验证码"   attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
    _captchaField.attributedPlaceholder = captchaPlaceHolderStr;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    
    _phoneNumField.firstSpacingPosition = 3;
    _phoneNumField.secondSpacingPosition = 8;
    _phoneNumField.maxLength = 11;
    _phoneNumField.finishBlock = ^(TCSpacingTextField *textField) {
        [weakSelf.passwordField becomeFirstResponder];
    };
    
    _phoneNum2Field.firstSpacingPosition = 3;
    _phoneNum2Field.secondSpacingPosition = 8;
    _phoneNum2Field.maxLength = 11;
    _phoneNum2Field.finishBlock = ^(TCSpacingTextField *textField) {
        [weakSelf.captchaField becomeFirstResponder];
    };
    
    
    GT3CaptchaManager *captchaManager = [[GT3CaptchaManager alloc] initWithAPI1:api_1 API2:api_2 timeout:5.0];
    captchaManager.delegate = self;
    UIColor *maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    captchaManager.maskColor = maskColor;
    _gt3Button = [[GT3CaptchaButton alloc] initWithFrame:CGRectZero captchaManager:captchaManager];
    [_gt3Button startCaptcha];
    [self.view addSubview:self.gt3Button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize contentSize = [_scrollView contentSize];
    CGSize newSize = CGSizeMake(contentSize.width * 2, contentSize.height);
    [_scrollView setContentSize:newSize];
}

- (void) loadPageAtIndex:(NSInteger)pageIndex
{
    NSLog(@"load page at index:%ld",pageIndex);
    if (pageIndex < 0 || pageIndex > 1)
    {
        return;
    }
    if (pageIndex != _currentPageIndex)
    {
        CGFloat xOffset = _scrollView.bounds.size.width * pageIndex;
        CGPoint newOffset = CGPointMake(xOffset, 0);
        [_scrollView setContentOffset:newOffset animated:YES];
        [_segmentControl setSelectedSegmentIndex:pageIndex];
        _currentPageIndex = pageIndex;
        [self onTapBlankArea:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        CGRect scrollViewRect = _scrollView.bounds;
        int pageIndex = round(scrollView.contentOffset.x / scrollViewRect.size.width);
        [self loadPageAtIndex:pageIndex];
    }
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    [_phoneNumField resignFirstResponder];
    [_phoneNum2Field resignFirstResponder];
    [_captchaField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void) loginSuccessWithToken:(NSString *)token
{
    
}

- (IBAction) onLoginButton:(id)sender
{
    NSLog(@"点击登录按钮");
    if (_currentPageIndex == 0)
    {
        NSLog(@"密码登录页面");
        NSString *phoneNum = _phoneNumField.plainPhoneNum;
        NSString *password = _passwordField.text;
        NSLog(@"phoneNum:%@ password:%@",phoneNum,password);
        if (!phoneNum || phoneNum.length == 0)
        {
            [MBProgressHUD showError:@"请输入手机号" toView:nil];
            return;
        }
        if (!password || password.length == 0)
        {
            [MBProgressHUD showError:@"请输入密码" toView:nil];
            return;
        }
        [_phoneNumField resignFirstResponder];
        [_passwordField resignFirstResponder];
        
        [MMProgressHUD showWithStatus:@"登录中"];
        TCPasswordLoginRequest *loginReq = [[TCPasswordLoginRequest alloc] initWithPhoneNumber:phoneNum password:password];
        [loginReq startWithSuccess:^(NSString *token) {
            NSLog(@"登录成功:%@",token);
            [[TCLocalAccount shared] setToken:token];
            TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
            [request startWithSuccess:^(TCUser *user) {
                NSLog(@"user:%@",user);
                user.token = token;
                [[TCLocalAccount shared] loginSuccess:user];
                TCTabBarController *tabBarController = [TCTabBarController new];
                [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
                [MMProgressHUD dismissWithSuccess:@"登录成功" title:nil afterDelay:1.32];
            } failure:^(NSString *message) {
                NSLog(@"msg:%@",message);
                [MMProgressHUD dismissWithError:@"登录失败"];
            }];
        } failure:^(NSString *message) {
            NSLog(@"fail:%@",message);
            [MMProgressHUD dismissWithError:message];
        }];
    }else
    {
        NSString *phoneNum = _phoneNum2Field.plainPhoneNum;
        NSString *captcha = _captchaField.text;
        NSLog(@"phoneNum:%@ captcha:%@",phoneNum,captcha);
        if (!phoneNum || phoneNum.length == 0)
        {
            [MBProgressHUD showError:@"请输入手机号" toView:nil];
            return;
        }
        if (!captcha || captcha.length == 0)
        {
            [MBProgressHUD showError:@"请输入验证码" toView:nil];
            return;
        }
        [_phoneNum2Field resignFirstResponder];
        [_captchaField resignFirstResponder];
        
        [MMProgressHUD showWithStatus:@"登录中"];
        TCCaptchaLoginRequest *loginReq = [[TCCaptchaLoginRequest alloc] initWithPhoneNumber:phoneNum captcha:captcha];
        [loginReq startWithSuccess:^(NSString *token) {
            [[TCLocalAccount shared] setToken:token];
            TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
            [request startWithSuccess:^(TCUser *user) {
                NSLog(@"user:%@",user);
                user.token = token;
                [[TCLocalAccount shared] loginSuccess:user];
                TCTabBarController *tabBarController = [TCTabBarController new];
                [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
                [MMProgressHUD dismissWithSuccess:@"登录成功" title:nil afterDelay:1.32];
            } failure:^(NSString *message) {
                NSLog(@"msg:%@",message);
                [MMProgressHUD dismissWithError:@"登录失败"];
            }];
        } failure:^(NSString *message, NSInteger errorCode){
            NSLog(@"message:%@ errorcode:%ld",message,errorCode);
            if (errorCode == 10404)
            {
                NSString *token = message;
                [[TCLocalAccount shared] setToken:token];
                TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
                [request startWithSuccess:^(TCUser *user) {
                    NSLog(@"user:%@",user);
                    user.token = token;
                    [[TCLocalAccount shared] loginSuccess:user];
                    [MMProgressHUD dismiss];
                    TCSetPasswordViewController *passwordVC = [TCSetPasswordViewController new];
                    [self.navigationController pushViewController:passwordVC animated:YES];
                } failure:^(NSString *message) {
                    NSLog(@"msg:%@",message);
                    [MMProgressHUD dismissWithError:message];
                }];
            }else if(errorCode == 10405)
            {
                TCGetGeetestDataRequest *request = [TCGetGeetestDataRequest new];
                [request startWithSuccess:^(NSString *gt, NSString *challenge) {
                    NSLog(@"gt:%@ \nchal:%@",gt,challenge);
                } failure:^(NSString *message) {
                    NSLog(@"get geetest fail:%@",message);
                }];
            }else
            {
                [MMProgressHUD dismissWithError:message];
            }
        }];
    }
}

- (IBAction) onGetCaptcha:(id)sender
{
    //[_gt3Button startCaptcha];
    //return;
    if (_phoneNum2Field.plainPhoneNum.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号" toView:nil];
        return;
    }
    [_captchaField becomeFirstResponder];
    if (_captchaButton.fetchState == FetchCaptchaStateNone ||
        _captchaButton.fetchState == FetchCaptchaStateRefetch)
    {
        __weak __typeof(self) weakSelf = self;
        TCGetCaptchaRequest *request = [[TCGetCaptchaRequest alloc] initWithPhoneNumber:_phoneNum2Field.plainPhoneNum];
        [request startWithSuccess:^(NSString *message) {
            [MBProgressHUD showSuccess:@"短信验证码已发送，请注意查收" toView:nil];
            [weakSelf.captchaButton setFetchState:FetchCaptchaStateCountdown];
        } failure:^(NSString *message, NSInteger errorCode) {
            if(errorCode == 10405)
            {
                /*
                TCGetGeetestDataRequest *request = [TCGetGeetestDataRequest new];
                [request startWithSuccess:^(NSString *gt, NSString *challenge) {
                    NSLog(@"gt:%@ \nchal:%@",gt,challenge);
                } failure:^(NSString *message) {
                    NSLog(@"get geetest fail:%@",message);
                }];
                 */
                NSLog(@"10405");
                //[_gt3Button startCaptcha];
                [weakSelf.captchaField resignFirstResponder];
                [weakSelf.gt3Button startCaptcha];
            }else
            {
                [MBProgressHUD showError:message toView:nil];
            }
        }];
    }
}

- (IBAction) onRegisterButton:(id)sender
{
    TCRegisterViewController *registerVC = [TCRegisterViewController new];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction) onForgetPasswordButton:(id)sender
{
    TCForgetPasswordViewController *forgetVC = [TCForgetPasswordViewController new];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *touchClass = NSStringFromClass([touch.view class]);
    NSLog(@"touch class:%@",touchClass);
    if ([touchClass isEqualToString:@"HMScrollView"])
    {
        return NO;
    }
    return YES;
}


#pragma mark - GT3CaptchaManagerDelegate
#pragma MARK - GT3CaptchaManagerDelegate

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
    //[TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
    [MBProgressHUD showError:error.localizedDescription toView:nil];
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"User Did Close GTView.");
}

/*
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy))decisionHandler {
    if (!error) {
        //处理你的验证结果
        NSLog(@"\nreceive sec data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //成功请调用decisionHandler(GT3SecondaryCaptchaPolicyAllow)
        decisionHandler(GT3SecondaryCaptchaPolicyAllow);
        //失败请调用decisionHandler(GT3SecondaryCaptchaPolicyForbidden)
        //decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        
        NSString *phoneNumStr = _phoneNum2Field.plainPhoneNum;
        TCGeetestCaptchaRequest *request = [[TCGeetestCaptchaRequest alloc] initWithPhoneNumber:phoneNumStr challenge:@"" validate:@"" seccode:@""];
        [request startWithSuccess:^(NSString *message) {
            NSLog(@"message:%@",message);
        } failure:^(NSString *message, NSInteger errorCode) {
            NSLog(@"fail msg:%@",message);
        }];
    }
    else {
        //二次验证发生错误
        decisionHandler(GT3SecondaryCaptchaPolicyForbidden);
        //[TipsView showTipOnKeyWindow:error.error_code fontSize:12.0];
        [MBProgressHUD showError:error.localizedDescription toView:nil];
    }
}
 
- (void)gtCaptcha:(GT3CaptchaManager *)manager willSendRequestAPI1:(NSURLRequest *)originalRequest withReplacedHandler:(void (^)(NSURLRequest *))replacedHandler {
    NSMutableURLRequest *mRequest = [originalRequest mutableCopy];
    NSString *newURL = [NSString stringWithFormat:@"%@?t=%.0f", originalRequest.URL.absoluteString, [[[NSDate alloc] init]timeIntervalSince1970]];
    mRequest.URL = [NSURL URLWithString:newURL];
    
    replacedHandler(mRequest);
}
 */

- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    __weak __typeof(self) weakSelf = self;
    NSString *challenge = [result objectForKey:@"geetest_challenge"];
    NSString *seccode = [result objectForKey:@"geetest_seccode"];
    NSString *validate = [result objectForKey:@"geetest_validate"];
    NSString *phoneNum = _phoneNum2Field.plainPhoneNum;
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
