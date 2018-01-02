//
//  TCAddTemplateViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddTemplateViewController.h"
#import "VHLNavigation.h"
#import "TCUser+CoreDataClass.h"
#import "TCAddCorpRequest.h"
#import "TCSuccessResultViewController.h"
#import "TCCorpHomeViewController.h"

@interface TCAddTemplateViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *nameField;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAddButton:(id)sender;
- (IBAction) onEditPermissionTemplate:(id)sender;
@end

@implementation TCAddTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增权限模版";
    //[self vhl_setNavBarHidden:NO];
    [self vhl_setNavBarTintColor:THEME_TINT_COLOR];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    
    NSAttributedString *namePlaceHolderStr = [[NSAttributedString alloc] initWithString:@"请输入新增模版的名称"   attributes:@{NSForegroundColorAttributeName:THEME_PLACEHOLDER_COLOR}];
    _nameField.attributedPlaceholder = namePlaceHolderStr;
    
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
}

- (IBAction) onAddButton:(id)sender
{
    NSLog(@"on register button");
    if (_nameField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入模版名称" toView:nil];
        return;
    }
    
    [_nameField resignFirstResponder];
    
    /*
    __weak __typeof(self) weakSelf = self;
    [MMProgressHUD showWithStatus:@"添加中..."];
    TCAddCorpRequest *request = [[TCAddCorpRequest alloc] initWithName:_nameField.text contact:_contactField.text phone:@""];
    [request startWithSuccess:^(NSInteger cid) {
        [MMProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_CORP object:nil];
        TCSuccessResultViewController *successVC = [[TCSuccessResultViewController alloc] initWithTitle:@"创建成功" desc:@"恭喜您成为公司管理员"];
        successVC.buttonTitle = @"查看我的企业";
        successVC.finishBlock = ^(UIViewController *viewController) {
            [MMProgressHUD showWithStatus:@"切换账号中"];
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
        [MMProgressHUD dismissWithError:message];
    }];
     */
}

- (IBAction) onEditPermissionTemplate:(id)sender
{
    NSLog(@"on edit permission template");
}
@end
