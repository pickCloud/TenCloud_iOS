//
//  TCMessageViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/17.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCMessageViewController.h"
#import "TCMessageTableViewController.h"
#import "TCMessageManager.h"

@interface TCMessageViewController ()

@end

@implementation TCMessageViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息盒子";
    self.view.backgroundColor = THEME_BACKGROUND_COLOR;
    
    if (self.navigationController.viewControllers.count >= 1) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchDown];
        UIImage *nomalImage = [UIImage imageNamed:@"public_back"];
        [button setImage:[nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [button sizeToFit];
        //[button setBackgroundColor:[UIColor redColor]];
        
        /*
         if (button.bounds.size.width < 40) {
         CGFloat width = 40 / button.bounds.size.height * button.bounds.size.width;
         button.bounds = CGRectMake(0, 0, width, 40);
         }
         if (button.bounds.size.height > 40) {
         CGFloat height = 40 / button.bounds.size.width * button.bounds.size.height;
         button.bounds = CGRectMake(0, 0, 40, height);
         }
         
         button.imageEdgeInsets = UIEdgeInsetsZero;
         */
        CGFloat btnOffset = TCSCALE(16);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -btnOffset, 0, 0);
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        //self.navigationItem.backBarButtonItem = nil;
        //self.navigationItem.backBarButtonItem = backButtonItem;
        
        //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    
    self.magicView.itemScale = 1.0;
    self.magicView.headerHeight = TCSCALE(44);//40;
    self.magicView.navigationHeight = TCSCALE(44); //40;
    
    self.magicView.itemSpacing = TCSCALE(29.5);
    //self.magicView.bounces = YES;
    //self.magicView.againstStatusBar = YES;
    //self.magicView.needPreloading = NO;
    self.magicView.bounces = YES;
    self.magicView.headerView.backgroundColor = THEME_TINT_COLOR; //RGBCOLOR(243, 40, 47);
    self.magicView.sliderColor = THEME_TINT_COLOR;
    self.magicView.navigationColor = TABLE_CELL_BG_COLOR;
    self.magicView.layoutStyle = VTLayoutStyleDivide;//VTLayoutStyleCenter;//VTLayoutStyleDefault;
    self.magicView.separatorHeight = 0.0f;
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //[self configSeparatorView];
    
    [self.magicView reloadData];
    [[TCMessageManager shared] clearMessageCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    [titleList addObject:@"最新消息"];
    [titleList addObject:@"历史消息"];
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
    if (pageIndex == 0)
    {
        controller = [[TCMessageTableViewController alloc] initWithStatus:0];
    }else if (pageIndex == 1)
    {
        controller = [[TCMessageTableViewController alloc] initWithStatus:1];
    }
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
