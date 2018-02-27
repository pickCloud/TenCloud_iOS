//
//  TCDataPermissionViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/2/6.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCDataPermissionViewController.h"
#import "TCPermissionNode+CoreDataClass.h"
#import <VTMagic/VTMagic.h>
#import "TCServerPermTableViewController.h"
#import "TCFilePermTableViewController.h"
#import "TCProjectPermTableViewController.h"
#import "TCEditingPermission.h"

@interface TCDataPermissionViewController () <VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong)   VTMagicController       *magicController;
@property (nonatomic, weak)  TCPermissionNode           *permissionNode;
@property (nonatomic, assign) PermissionVCState         state;
@end

@implementation TCDataPermissionViewController

- (id) initWithPermissionNode:(TCPermissionNode*)node state:(PermissionVCState)state
{
    self = [super init];
    if (self)
    {
        _permissionNode = node;
        _state = state;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self addChildViewController:self.magicController];
    CGRect viewRect = self.view.frame;
    viewRect.size.width = screenRect.size.width;
    CGFloat rectY = 0;
    CGFloat rectH = viewRect.size.height - rectY;
    CGRect rect = CGRectMake(0, rectY, viewRect.size.width, rectH);
    _magicController.view.frame = rect;
    _magicController.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_magicController.view];
    [_magicController.magicView reloadData];
}

- (void)viewDidLayoutSubviews
{
    CGRect viewRect = self.view.frame;
    viewRect.origin.x = 0;
    _magicController.view.frame = viewRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (VTMagicController *)magicController
{
    if (!_magicController)
    {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.itemScale = 1.0;
        _magicController.magicView.headerHeight = 0;
        _magicController.magicView.navigationHeight = 40;//TCSCALE(44);
        
        _magicController.magicView.itemSpacing = TCSCALE(29.5);
        _magicController.magicView.bounces = YES;
        _magicController.magicView.headerView.backgroundColor = THEME_TINT_COLOR;
        _magicController.magicView.sliderColor = [UIColor clearColor];//THEME_TINT_COLOR;
        UIColor *navBgColor = [UIColor colorWithRed:29/255.0 green:32/255.0 blue:41/255.0 alpha:1.0];
        _magicController.magicView.navigationColor = navBgColor;
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
    [titleList addObject:@"服务器"];
    [titleList addObject:@"项目"];
    [titleList addObject:@"文件服务"];
    return titleList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:THEME_PLACEHOLDER_COLOR forState:UIControlStateNormal];
        [menuItem setTitleColor:THEME_TEXT_COLOR forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    UIViewController *controller = nil;
    controller = [UIViewController new];
    
    TCPermissionNode *node = nil;
    if (pageIndex == 0)
    {
        if (_permissionNode.data.count > 2)
        {
            node = [_permissionNode.data objectAtIndex:2];
        }
        controller = [[TCServerPermTableViewController alloc] initWithPermissionNode:node state:_state];
    }else if(pageIndex == 1)
    {
        if (_permissionNode.data.count > 1)
        {
            node = [_permissionNode.data objectAtIndex:1];
        }
        controller = [[TCProjectPermTableViewController alloc] initWithPermissionNode:node state:_state];
    }else
    {
        if (_permissionNode.data.count > 0)
        {
            node = [_permissionNode.data objectAtIndex:0];
        }
        controller = [[TCFilePermTableViewController alloc] initWithPermissionNode:node state:_state];
    }
    return controller;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    
}

@end
