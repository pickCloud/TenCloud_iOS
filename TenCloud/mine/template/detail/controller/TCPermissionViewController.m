//
//  TCPermissionViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCPermissionViewController.h"
#import "TCPermissionTableViewController.h"
#import "TCEditingTemplate.h"
#import "TCPermissionSegment+CoreDataClass.h"
#import <VTMagic/VTMagic.h>
#import "TCModifyPermissionRequest.h"
#import "TCTemplate+CoreDataClass.h"

@interface TCPermissionViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong)   VTMagicController           *magicController;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topHeightConstraint;
@property (nonatomic, weak) IBOutlet    UILabel             *titleLabel;
- (IBAction) onCloseButton:(id)sender;
- (IBAction) onConfirmButton:(id)sender;
@end

@implementation TCPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_iPhoneX)
    {
        _topHeightConstraint.constant = 64+27;
    }
    
    if (_state == PermissionVCStateNew)
    {
        self.titleLabel.text = @"模版权限选择";
    }else
    {
        self.titleLabel.text = @"修改模版权限";
    }
    
    [self addChildViewController:self.magicController];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat rectY = _topHeightConstraint.constant;
    CGFloat rectH = screenRect.size.height - rectY;
    CGRect rect = CGRectMake(0, rectY, screenRect.size.width, rectH);
    _magicController.view.frame = rect;
    _magicController.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_magicController.view];
    [_magicController.magicView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - extension
- (IBAction) onCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) onConfirmButton:(id)sender
{
    if (_state == PermissionVCStateEdit)
    {
        __weak __typeof(self) weakSelf = self;
        [MMProgressHUD showWithStatus:@"修改权限中"];
        TCEditingTemplate *tmpl = [TCEditingTemplate shared];
        TCModifyPermissionRequest *req = [TCModifyPermissionRequest new];
        req.templateID = _tmpl.tid;
        req.name = _tmpl.name;
        req.funcPermissionArray = tmpl.permissionIDArray;
        req.projectPermissionArray = tmpl.projectPermissionIDArray;
        req.filePermissionArray = tmpl.filePermissionIDArray;
        req.serverPermissionArray = tmpl.serverPermissionIDArray;
        [req startWithSuccess:^(NSString *message) {
            [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *message) {
            [MMProgressHUD dismissWithError:message afterDelay:1.32];
        }];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (VTMagicController *)magicController
{
    if (!_magicController)
    {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.itemScale = 1.0;
        _magicController.magicView.headerHeight = 0;
        _magicController.magicView.navigationHeight = TCSCALE(44);
        
        _magicController.magicView.itemSpacing = TCSCALE(29.5);
        _magicController.magicView.bounces = YES;
        _magicController.magicView.headerView.backgroundColor = THEME_TINT_COLOR;
        _magicController.magicView.sliderColor = THEME_TINT_COLOR;
        _magicController.magicView.navigationColor = TABLE_CELL_BG_COLOR;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.separatorHeight = 0.0f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}



#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    TCEditingTemplate *editingTemplate = [TCEditingTemplate shared];
    NSArray *segmentArray = editingTemplate.permissionSegArray;
    for (TCPermissionSegment *seg in segmentArray)
    {
        [titleList addObject:seg.name];
    }
    return titleList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        UIColor *normalColor = [UIColor colorWithRed:137/255.0 green:154/255.0 blue:182/255.0 alpha:1.0];
        [menuItem setTitleColor:normalColor forState:UIControlStateNormal];
        [menuItem setTitleColor:THEME_TINT_COLOR forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    UIViewController *controller = nil;
    TCPermissionSegment *seg = [[[TCEditingTemplate shared] permissionSegArray] objectAtIndex:pageIndex];
    controller = [[TCPermissionTableViewController alloc] initWithPermissionSegment:seg];
    return controller;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    //    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}
@end
