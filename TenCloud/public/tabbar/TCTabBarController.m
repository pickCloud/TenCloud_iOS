//
//  TCTabBarController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCTabBarController.h"
#import "TCServerHomeViewController.h"
#import "TCProjectHomeViewController.h"
#import "TCResourceHomeViewController.h"
#import "TCDiscoverHomeViewController.h"
#import "TCCurrentCorp.h"
#import "TCPersonHomeViewController.h"
#import "TCCorpHomeViewController.h"

#import "TCServiceHomeViewController.h"
#import "TCLogHomeViewController.h"
#import "TCMirrorHomeViewController.h"

@interface TCTabBarController ()

@end

@implementation TCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:THEME_TEXT_COLOR} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:THEME_TINT_COLOR} forState:UIControlStateSelected];
    
    UIColor *barBgColor = [UIColor colorWithRed:47/255.0 green:53/255.0 blue:67/255.0 alpha:1.0];
    [[UITabBar appearance] setBarTintColor:barBgColor];
    self.tabBar.tintColor = THEME_TINT_COLOR; //[UIColor cyanColor];
    
    TCServerHomeViewController *serverHomeVC = [TCServerHomeViewController new];
    UINavigationController *serverHomeNav = [[UINavigationController alloc] initWithRootViewController:serverHomeVC];
    UIImage *serverSelIcon = [UIImage imageNamed:@"tabbar_server_selected"];
    UIImage *serverIcon = [[UIImage imageNamed:@"tabbar_server"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    serverHomeNav.tabBarItem.image = serverIcon;
    serverHomeNav.tabBarItem.selectedImage = serverSelIcon;
    serverHomeNav.tabBarItem.title = @"主机/集群";
    [self addChildViewController:serverHomeNav];
    
    TCServiceHomeViewController *serviceHomeVC = [TCServiceHomeViewController new];
    UINavigationController *serviceHomeNav = [[UINavigationController alloc] initWithRootViewController:serviceHomeVC];
    UIImage *serviceSelIcon = [UIImage imageNamed:@"tabbar_project_selected"];
    UIImage *serviceIcon = [[UIImage imageNamed:@"tabbar_project"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    serviceHomeNav.tabBarItem.image = serviceIcon;
    serviceHomeNav.tabBarItem.selectedImage = serviceSelIcon;
    serviceHomeNav.tabBarItem.title = @"应用/服务";
    [self addChildViewController:serviceHomeNav];
    
    TCLogHomeViewController *logHomeVC = [TCLogHomeViewController new];
    UINavigationController *logNav = [[UINavigationController alloc] initWithRootViewController:logHomeVC];
    UIImage *logSelIcon = [UIImage imageNamed:@"tabbar_project_selected"];
    UIImage *logIcon = [[UIImage imageNamed:@"tabbar_project"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    logNav.tabBarItem.image = logIcon;
    logNav.tabBarItem.selectedImage = logSelIcon;
    logNav.tabBarItem.title = @"日志/事件";
    [self addChildViewController:logNav];
    
    TCMirrorHomeViewController *mirrorHomeVC = [TCMirrorHomeViewController new];
    UINavigationController *mirrorNav = [[UINavigationController alloc] initWithRootViewController:mirrorHomeVC];
    UIImage *mirrorSelIcon = [UIImage imageNamed:@"tabbar_project_selected"];
    UIImage *mirrorIcon = [[UIImage imageNamed:@"tabbar_project"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mirrorNav.tabBarItem.image = mirrorIcon;
    mirrorNav.tabBarItem.selectedImage = mirrorSelIcon;
    mirrorNav.tabBarItem.title = @"镜像";
    [self addChildViewController:mirrorNav];
    /*
    TCProjectHomeViewController *projectHomeVC = [TCProjectHomeViewController new];
    UINavigationController *projectHomeNav = [[UINavigationController alloc] initWithRootViewController:projectHomeVC];
    UIImage *projectSelIcon = [UIImage imageNamed:@"tabbar_project_selected"];
    UIImage *projectIcon = [[UIImage imageNamed:@"tabbar_project"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    projectHomeNav.tabBarItem.image = projectIcon;
    projectHomeNav.tabBarItem.selectedImage = projectSelIcon;
    projectHomeNav.tabBarItem.title = @"项目";
    [self addChildViewController:projectHomeNav];
    
    TCResourceHomeViewController *resourceHomeVC = [TCResourceHomeViewController new];
    UINavigationController *resourceHomeNav = [[UINavigationController alloc] initWithRootViewController:resourceHomeVC];
    UIImage *resourceSelIcon = [UIImage imageNamed:@"tabbar_resource_selected"];
    UIImage *resourceIcon = [[UIImage imageNamed:@"tabbar_resource"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    resourceHomeNav.tabBarItem.image = resourceIcon;
    resourceHomeNav.tabBarItem.selectedImage = resourceSelIcon;
    resourceHomeNav.tabBarItem.title = @"资源";
    [self addChildViewController:resourceHomeNav];
    
    TCDiscoverHomeViewController *discoverHomeVC = [TCDiscoverHomeViewController new];
    UINavigationController *discoverHomeNav = [[UINavigationController alloc] initWithRootViewController:discoverHomeVC];
    UIImage *discoverSelIcon = [UIImage imageNamed:@"tabbar_discover_selected"];
    UIImage *discoverIcon = [[UIImage imageNamed:@"tabbar_discover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverHomeNav.tabBarItem.image = discoverIcon;
    discoverHomeNav.tabBarItem.selectedImage = discoverSelIcon;
    discoverHomeNav.tabBarItem.title = @"发现";
    [self addChildViewController:discoverHomeNav];
    */
    
    UIViewController *mineHomeVC = nil;
    TCCurrentCorp *corp = [TCCurrentCorp shared];
    if (corp && corp.exist)
    {
        mineHomeVC = [[TCCorpHomeViewController alloc] initWithCorpID:corp.cid];
    }else
    {
        mineHomeVC = [TCPersonHomeViewController new];
    }
    UINavigationController *mineHomeNav = [[UINavigationController alloc] initWithRootViewController:mineHomeVC];
    UIImage *mineSelIcon = [UIImage imageNamed:@"tabbar_mine_selected"];
    UIImage *mineIcon = [[UIImage imageNamed:@"tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineHomeNav.tabBarItem.image = mineIcon;
    mineHomeNav.tabBarItem.selectedImage = mineSelIcon;
    mineHomeNav.tabBarItem.title = @"我的";
    [self addChildViewController:mineHomeNav];
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

@end
