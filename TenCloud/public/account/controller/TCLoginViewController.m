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

@interface TCLoginViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet    HMSegmentedControl  *segmentControl;
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneNumField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneNum2Field;
@property (nonatomic, weak) IBOutlet    UITextField         *captchaField;
@property (nonatomic, weak) IBOutlet    GetCaptchaButton    *captchaButton;
@property (nonatomic, weak) IBOutlet    UIScrollView        *scrollView;
@property (nonatomic, assign)   NSInteger                   currentPageIndex;
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
    UIFont *titleFont = [UIFont systemFontOfSize:TCSCALE(15.0)];
    _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : titleFont };
    UIFont *selectedFont = [UIFont boldSystemFontOfSize:TCSCALE(16.1)];
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : THEME_TINT_COLOR, NSFontAttributeName : selectedFont };
    _segmentControl.selectionIndicatorColor = THEME_TINT_COLOR;
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    //HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.shouldAnimateUserSelection = YES;
    //_segmentControl.userInteractionEnabled = YES;
    
    UIColor *placeHolderColor = [UIColor grayColor];
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
    NSLog(@"content size:%.2f,%.2f",contentSize.width, contentSize.height);
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
        } failure:^(NSString *message) {
            [MMProgressHUD dismissWithError:message];
        }];
    }
}

- (IBAction) onGetCaptcha:(id)sender
{
    if (_phoneNum2Field.plainPhoneNum.length == 0)
    {
        [MBProgressHUD showError:@"请输入手机号" toView:nil];
        return;
    }
    if (_captchaButton.fetchState == FetchCaptchaStateNone ||
        _captchaButton.fetchState == FetchCaptchaStateRefetch)
    {
        [_captchaButton setFetchState:FetchCaptchaStateCountdown];
        TCGetCaptchaRequest *request = [[TCGetCaptchaRequest alloc] initWithPhoneNumber:_phoneNum2Field.plainPhoneNum];
        [request startWithSuccess:^(NSString *message) {
            [MBProgressHUD showSuccess:@"短信验证码已发送，请注意查收" toView:nil];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }
}

- (IBAction) onRegisterButton:(id)sender
{
    NSLog(@"注册");
    TCRegisterViewController *registerVC = [TCRegisterViewController new];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction) onForgetPasswordButton:(id)sender
{
    NSLog(@"忘记密码");
    TCForgetPasswordViewController *forgetVC = [TCForgetPasswordViewController new];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //return !(self.inputing);
    NSString *touchClass = NSStringFromClass([touch.view class]);
    NSLog(@"touch class:%@",touchClass);
    if ([touchClass isEqualToString:@"HMScrollView"])
    {
        return NO;
    }
    return YES;
}
@end
