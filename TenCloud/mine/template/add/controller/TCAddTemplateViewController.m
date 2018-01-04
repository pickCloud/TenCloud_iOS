//
//  TCAddTemplateViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAddTemplateViewController.h"
#import "VHLNavigation.h"
//#import "TCUser+CoreDataClass.h"

#import "TCPermissionViewController.h"
#import "TCEditingTemplate.h"
#import "TCAddTemplateRequest.h"
#import "TCSuccessResultViewController.h"

@interface TCAddTemplateViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    UITextField         *nameField;
@property (nonatomic, weak) IBOutlet    UILabel             *permissionDescLabel;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAddButton:(id)sender;
- (IBAction) onEditPermissionTemplate:(id)sender;
- (void) updatePermissionDescLabel;
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
    [[TCEditingTemplate shared] reset];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatePermissionDescLabel];
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
    if (_nameField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入模版名称" toView:nil];
        return;
    }
    
    [_nameField resignFirstResponder];
    
    TCEditingTemplate *tmpl = [TCEditingTemplate shared];
    //NSLog(@"per ids:%@",tmpl.permissionIDArray);
    //NSLog(@"server ids:%@",tmpl.serverPermissionIDArray);
    //NSLog(@"proj ids:%@",tmpl.projectPermissionIDArray);
    //NSLog(@"file ids:%@",tmpl.filePermissionIDArray);
    
    __weak __typeof(self) weakSelf = self;
    TCAddTemplateRequest *request = nil;
    [MMProgressHUD showWithStatus:@"新增模版中"];
    request = [[TCAddTemplateRequest alloc] initWithName:_nameField.text
                                             permissions:tmpl.permissionIDArray
                                       serverPermissions:tmpl.serverPermissionIDArray
                                      projectPermissions:tmpl.projectPermissionIDArray
                                         filePermissions:tmpl.filePermissionIDArray];
    [request startWithSuccess:^(NSString *message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADD_TEMPLATE object:nil];
        /*
        NSString *desc = [NSString stringWithFormat:@"权限模版 %@ 新增成功",weakSelf.nameField.text];
        TCSuccessResultViewController *successVC = [[TCSuccessResultViewController alloc] initWithTitle:@"新增成功" desc:desc];
        successVC.buttonTitle = @"查看模版列表";
        successVC.finishBlock = ^(UIViewController *viewController) {
            [viewController.navigationController popViewControllerAnimated:YES];
        };
        NSArray *viewControllers = self.navigationController.viewControllers;
        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
        [newVCS removeLastObject];
        [newVCS addObject:successVC];
        [weakSelf.navigationController setViewControllers:newVCS];
         */
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [MMProgressHUD dismissWithSuccess:@"新增成功" title:nil afterDelay:1.32];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
    }];
    
}

- (IBAction) onEditPermissionTemplate:(id)sender
{
    NSLog(@"on edit permission template");
    TCPermissionViewController *perVC = [TCPermissionViewController new];
    perVC.state = PermissionVCStateNew;
    [self presentViewController:perVC animated:YES completion:nil];
}

- (void) updatePermissionDescLabel
{
    NSInteger funcAmount = [[TCEditingTemplate shared] funcPermissionAmount];
    NSInteger dataAmount = [[TCEditingTemplate shared] dataPermissionAmount];
    if (funcAmount == 0 && dataAmount == 0)
    {
        [_permissionDescLabel setText:@"未选择"];
    }else
    {
        NSString *desc = [NSString stringWithFormat:@"功能权限 %ld 项  数据权限 %ld 项",funcAmount,dataAmount];
        _permissionDescLabel.text = desc;
    }
}
@end
