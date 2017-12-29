//
//  TCServerDetailViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/13.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerDetailViewController.h"
#import "TCServerMonitorViewController.h"
#import "TCServerInfoViewController.h"
#import "TCServerConfigViewController.h"
#import "TCServerContainerTableViewController.h"
#import "TCServerLogTableViewController.h"
#import "TCServer+CoreDataClass.h"

@interface TCServerDetailViewController ()
@property (nonatomic, strong)   TCServer    *server;
@end

@implementation TCServerDetailViewController

- (instancetype) initWithServer:(TCServer*)server
{
    self = [super init];
    if (self)
    {
        _server = server;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _server.name;
    self.view.backgroundColor = THEME_BACKGROUND_COLOR;
    //self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
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
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.separatorHeight = 0.0f;
    //self.edgesForExtendedLayout = UIRectEdgeAll;
    //[self configSeparatorView];
    
    [self.magicView reloadData];
}

-(void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    [titleList addObject:@" 监控 "];
    [titleList addObject:@"基本信息"];
    [titleList addObject:@"配置信息"];
    [titleList addObject:@"容器列表"];
    [titleList addObject:@"日志"];
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
        controller = [[TCServerMonitorViewController alloc] initWithID:_server.serverID];
    }else if (pageIndex == 1)
    {
        controller = [[TCServerInfoViewController alloc] initWithServer:_server];
    }else if(pageIndex == 2)
    {
        controller = [[TCServerConfigViewController alloc] initWithID:_server.serverID];
    }else if(pageIndex == 3)
    {
        controller = [[TCServerContainerTableViewController alloc] initWithID:_server.serverID];
    }else if(pageIndex == 4)
    {
        controller = [[TCServerLogTableViewController alloc] initWithID:_server.serverID];
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
