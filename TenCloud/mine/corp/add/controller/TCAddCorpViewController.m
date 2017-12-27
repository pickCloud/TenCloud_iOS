//
//  TCAddCorpViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddCorpViewController.h"
#import "VHLNavigation.h"
#import "TCUser+CoreDataClass.h"
#import "TCSpacingTextField.h"
#import "TCAddCorpRequest.h"
#import "TCSuccessResultViewController.h"

@interface TCAddCorpViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *nameField;
@property (nonatomic, weak) IBOutlet    UITextField         *contactField;
@property (nonatomic, weak) IBOutlet    TCSpacingTextField  *phoneField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAddButton:(id)sender;
@end

@implementation TCAddCorpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加新企业";
    //[self vhl_setNavBarHidden:NO];
    [self vhl_setNavBarTintColor:THEME_TINT_COLOR];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    _phoneField.firstSpacingPosition = 3;
    _phoneField.secondSpacingPosition = 8;
    _phoneField.maxLength = 11;
    
    NSAttributedString *namePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"完整的企业名称"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _nameField.attributedPlaceholder = namePlaceHolderStr;
    NSAttributedString *contactPlaceHolderStr = [[NSAttributedString alloc] initWithString:@"联系人姓名"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _contactField.attributedPlaceholder = contactPlaceHolderStr;
    NSAttributedString *phonePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"手机号码"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _phoneField.attributedPlaceholder = phonePlaceHolderStr;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    NSLog(@"on tap blank area");
    [_nameField resignFirstResponder];
    [_contactField resignFirstResponder];
    [_phoneField resignFirstResponder];
}

- (IBAction) onAddButton:(id)sender
{
    NSLog(@"on register button");
    if (_nameField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入企业名称" toView:nil];
        return;
    }
    if (_contactField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入联系人" toView:nil];
        return;
    }
    if (_phoneField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入联系方式" toView:nil];
        return;
    }
    
    [_nameField resignFirstResponder];
    [_contactField resignFirstResponder];
    [_phoneField resignFirstResponder];
    
    __weak __typeof(self) weakSelf = self;
    [MMProgressHUD showWithStatus:@"添加中..."];
    TCAddCorpRequest *request = [[TCAddCorpRequest alloc] initWithName:_nameField.text contact:_contactField.text phone:_phoneField.plainPhoneNum];
    [request startWithSuccess:^(NSString *message) {
        [MMProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_CORP object:nil];
        TCSuccessResultViewController *successVC = [[TCSuccessResultViewController alloc] initWithTitle:@"创建成功" desc:@"恭喜您成为公司管理员"];
        successVC.buttonTitle = @"查看我的企业";
        successVC.finishBlock = ^(UIViewController *viewController) {
            [viewController.navigationController popViewControllerAnimated:YES];
        };
        NSArray *viewControllers = self.navigationController.viewControllers;
        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
        [newVCS removeLastObject];
        [newVCS addObject:successVC];
        [weakSelf.navigationController setViewControllers:newVCS];
        
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
}

@end