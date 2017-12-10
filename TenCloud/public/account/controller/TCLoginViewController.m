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

//for test
#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
//#import "TCClusterRequest.h"

@interface TCLoginViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet    HMSegmentedControl  *segmentControl;
@property (nonatomic, weak) IBOutlet    UITextField         *phoneNumField;
@property (nonatomic, weak) IBOutlet    UITextField         *passwordField;
@property (nonatomic, weak) IBOutlet    UITextField         *phoneNum2Field;
@property (nonatomic, weak) IBOutlet    UITextField         *captchaField;
@property (nonatomic, weak) IBOutlet    UIScrollView        *scrollView;
@property (nonatomic, assign)   NSInteger                   currentPageIndex;
- (void) loadPageAtIndex:(NSInteger)pageIndex;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onLoginButton:(id)sender;
- (IBAction) onRegisterButton:(id)sender;
- (IBAction) onForgetPasswordButton:(id)sender;
@end

@implementation TCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view addGestureRecognizer:tapGesture];
    
    /*
    TCUserProfileRequest *request = [[TCUserProfileRequest alloc] init];
    [request startWithSuccess:^(TCUser *user) {
        NSLog(@"user:%@",user);
    } failure:^(NSString *message) {
        NSLog(@"msg:%@",message);
    }];
    
    TCClusterRequest *request = [[TCClusterRequest alloc] init];
    [request startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        NSLog(@"severArray:%@",serverArray);
    } failure:^(NSString *message) {
        NSLog(@"msg:%@",message);
    }];
     */
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
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"did end decelerating");
    if (scrollView == self.scrollView)
    {
        //CGRect scrollViewRect = _mScrollView.bounds;
        //int pageIndex = (int)scrollView.contentOffset.x / scrollViewRect.size.width;
        //[self loadPageAtIndex:pageIndex];
        CGRect scrollViewRect = _scrollView.bounds;
        //NSLog(@"width:%.2f offset_x:%.2f",scrollViewRect.size.width, scrollView.contentOffset.x);
        //CGFloat page = scrollView.contentOffset.x / scrollViewRect.size.width;
        //NSLog(@"page %.5f",page);
        //int pageIndex = (int)(scrollView.contentOffset.x / scrollViewRect.size.width);
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

- (IBAction) onLoginButton:(id)sender
{
    NSLog(@"点击登录按钮");
    if (_currentPageIndex == 0)
    {
        NSLog(@"密码登录页面");
        NSString *phoneNum = _phoneNumField.text;
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
        NSLog(@"验证码登录页面");
    }
}

- (IBAction) onRegisterButton:(id)sender
{
    NSLog(@"注册");
}

- (IBAction) onForgetPasswordButton:(id)sender
{
    NSLog(@"忘记密码");
}
@end
