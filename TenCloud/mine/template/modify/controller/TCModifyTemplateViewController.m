//
//  TCModifyTemplateViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCModifyTemplateViewController.h"
#import "TCPermissionViewController.h"
#import "TCEditingPermission.h"
//#import "TCSuccessResultViewController.h"
#import "TCTemplate+CoreDataClass.h"
#import "TCModifyTextViewController.h"
#import "TCRenameTemplateRequest.h"

@interface TCModifyTemplateViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    UILabel             *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel             *permissionDescLabel;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, strong)   TCTemplate                  *mTemplate;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onModifyTemplateName:(id)sender;
- (IBAction) onEditPermissionTemplate:(id)sender;
- (void) updatePermissionDescLabel;
@end

@implementation TCModifyTemplateViewController

- (instancetype) initWithTemplate:(TCTemplate*)tmpl
{
    self = [super init];
    if (self)
    {
        _mTemplate = tmpl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改权限模版";
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    _nameLabel.text = _mTemplate.name;
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    [[TCEditingPermission shared] reset];
    [[TCEditingPermission shared] setTemplate:_mTemplate];
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
    //[_nameField resignFirstResponder];
}

- (IBAction) onModifyTemplateName:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    TCModifyTextViewController *modifyVC = [TCModifyTextViewController new];
    modifyVC.titleText = @"修改模版名称";
    modifyVC.initialValue = _mTemplate.name;
    modifyVC.placeHolder = @"模版名称";
    modifyVC.valueChangedBlock = ^(TCModifyTextViewController *vc, id newValue) {
        weakSelf.mTemplate.name = newValue;
        weakSelf.nameLabel.text = newValue;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MODIFY_TEMPLATE         object:nil];
    };
    modifyVC.requestBlock = ^(TCModifyTextViewController *vc, NSString *newValue) {
        TCRenameTemplateRequest *request = [[TCRenameTemplateRequest alloc] initWithTemplateID:_mTemplate.tid name:newValue];
        [request startWithSuccess:^(NSString *message) {
            [vc modifyRequestResult:YES message:@"修改成功"];
        } failure:^(NSString *message) {
            [vc modifyRequestResult:NO message:message];
        }];
    };
    [self.navigationController pushViewController:modifyVC animated:YES];
}

- (IBAction) onEditPermissionTemplate:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    TCPermissionViewController *perVC = [TCPermissionViewController new];
    perVC.state = PermissionVCStateEdit;
    perVC.tmpl = _mTemplate;
    perVC.modifiedBlock = ^(TCPermissionViewController *vc) {
        TCEditingPermission *perm = [TCEditingPermission shared];
        weakSelf.mTemplate.access_filehub = perm.filePermissionIDString;
        weakSelf.mTemplate.access_servers = perm.serverPermissionIDString;
        weakSelf.mTemplate.access_projects = perm.projectPermissionIDString;
        weakSelf.mTemplate.permissions = perm.permissionIDString;
        [weakSelf updatePermissionDescLabel];
    };
    [self presentViewController:perVC animated:YES completion:nil];
}

- (void) updatePermissionDescLabel
{
    long funcAmount = [[TCEditingPermission shared] funcPermissionAmount];
    long dataAmount = [[TCEditingPermission shared] dataPermissionAmount];
    if (funcAmount == 0 && dataAmount == 0)
    {
        [_permissionDescLabel setText:@"请选择"];
    }else
    {
        NSString *desc = [NSString stringWithFormat:@"功能权限 %ld 项  数据权限 %ld 项",funcAmount,dataAmount];
        _permissionDescLabel.text = desc;
    }
}
@end
