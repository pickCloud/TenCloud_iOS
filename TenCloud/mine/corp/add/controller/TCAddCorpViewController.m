//
//  TCAddCorpViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddCorpViewController.h"
#import "TCUser+CoreDataClass.h"
#import "TCSpacingTextField.h"
#import "TCAddCorpRequest.h"
#import "TCSuccessResultViewController.h"
#import "TCFailResultViewController.h"
#import "TCCorpHomeViewController.h"
#import "TCDissentViewController.h"
#import "TCCurrentCorp.h"

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
    [request startWithSuccess:^(NSInteger cid) {
        [MMProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_CORP object:nil];
        TCSuccessResultViewController *successVC = [[TCSuccessResultViewController alloc] initWithTitle:@"创建成功" desc:@"恭喜您成为公司管理员"];
        successVC.buttonTitle = @"查看我的公司";
        successVC.finishBlock = ^(UIViewController *viewController) {
            [MMProgressHUD showWithStatus:@"切换身份中"];
            [[TCCurrentCorp shared] setCid:cid];
            TCCorpHomeViewController *corpHome = [[TCCorpHomeViewController alloc] initWithCorpID:cid];
            NSArray *oldVCS = weakSelf.navigationController.viewControllers;
            NSMutableArray *vcs = [NSMutableArray arrayWithArray:oldVCS];
            [vcs removeAllObjects];
            [vcs addObject:corpHome];
            [viewController.navigationController setViewControllers:vcs animated:YES];
            [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:1.32];
        };
        NSArray *viewControllers = self.navigationController.viewControllers;
        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
        [newVCS removeLastObject];
        [newVCS addObject:successVC];
        [weakSelf.navigationController setViewControllers:newVCS];
        
    } failure:^(NSString *message) {
        [MMProgressHUD dismiss];
        TCFailResultViewController *failVC = [[TCFailResultViewController alloc] initWithTitle:@"创建失败" desc:message];
        failVC.buttonTitle = @"提起企业异议";
        failVC.finishBlock = ^(UIViewController *viewController) {
            TCDissentViewController *dissentVC = [TCDissentViewController new];
            NSArray *oldVCS = viewController.navigationController.viewControllers;
            NSMutableArray *vcs = [NSMutableArray arrayWithArray:oldVCS];
            [vcs removeLastObject];
            [vcs addObject:dissentVC];
            [viewController.navigationController setViewControllers:vcs animated:YES];
        };
        NSArray *viewControllers = weakSelf.navigationController.viewControllers;
        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
        [newVCS removeLastObject];
        [newVCS addObject:failVC];
        [weakSelf.navigationController setViewControllers:newVCS];
    }];
}

@end
