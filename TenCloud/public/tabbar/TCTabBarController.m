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
#import "TCMineHomeViewController.h"

@interface TCTabBarController ()

@end

@implementation TCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    //[[UITabBar appearance] setBackgroundColor:[UIColor darkGrayColor]];
    UIColor *barBgColor = [UIColor colorWithRed:47/255.0 green:53/255.0 blue:67/255.0 alpha:1.0];
    [[UITabBar appearance] setBarTintColor:barBgColor];
    self.tabBar.tintColor = THEME_TINT_COLOR; //[UIColor cyanColor];
    
    TCServerHomeViewController *serverHomeVC = [TCServerHomeViewController new];
    UINavigationController *serverHomeNav = [[UINavigationController alloc] initWithRootViewController:serverHomeVC];
    UIImage *serverSelIcon = [UIImage imageNamed:@"tabbar_server_selected"];
    UIImage *serverIcon = [UIImage imageNamed:@"tabbar_server"];
    serverHomeNav.tabBarItem.image = serverIcon;
    serverHomeNav.tabBarItem.selectedImage = serverSelIcon;
    serverHomeNav.tabBarItem.title = @"服务器";
    [self addChildViewController:serverHomeNav];
    
    TCProjectHomeViewController *projectHomeVC = [TCProjectHomeViewController new];
    UINavigationController *projectHomeNav = [[UINavigationController alloc] initWithRootViewController:projectHomeVC];
    UIImage *projectSelIcon = [UIImage imageNamed:@"tabbar_project_selected"];
    UIImage *projectIcon = [UIImage imageNamed:@"tabbar_project"];
    projectHomeNav.tabBarItem.image = projectIcon;
    projectHomeNav.tabBarItem.selectedImage = projectSelIcon;
    projectHomeNav.tabBarItem.title = @"项目";
    [self addChildViewController:projectHomeNav];
    
    TCResourceHomeViewController *resourceHomeVC = [TCResourceHomeViewController new];
    UINavigationController *resourceHomeNav = [[UINavigationController alloc] initWithRootViewController:resourceHomeVC];
    UIImage *resourceSelIcon = [UIImage imageNamed:@"tabbar_resource_selected"];
    UIImage *resourceIcon = [UIImage imageNamed:@"tabbar_resource"];
    resourceHomeNav.tabBarItem.image = resourceIcon;
    resourceHomeNav.tabBarItem.selectedImage = resourceSelIcon;
    resourceHomeNav.tabBarItem.title = @"资源";
    [self addChildViewController:resourceHomeNav];
    
    TCDiscoverHomeViewController *discoverHomeVC = [TCDiscoverHomeViewController new];
    UINavigationController *discoverHomeNav = [[UINavigationController alloc] initWithRootViewController:discoverHomeVC];
    UIImage *discoverSelIcon = [UIImage imageNamed:@"tabbar_discover_selected"];
    UIImage *discoverIcon = [UIImage imageNamed:@"tabbar_discover"];
    discoverHomeNav.tabBarItem.image = discoverIcon;
    discoverHomeNav.tabBarItem.selectedImage = discoverSelIcon;
    discoverHomeNav.tabBarItem.title = @"发现";
    [self addChildViewController:discoverHomeNav];
    
    TCMineHomeViewController *mineHomeVC = [TCMineHomeViewController new];
    UINavigationController *mineHomeNav = [[UINavigationController alloc] initWithRootViewController:mineHomeVC];
    UIImage *mineSelIcon = [UIImage imageNamed:@"tabbar_mine_selected"];
    UIImage *mineIcon = [UIImage imageNamed:@"tabbar_mine"];
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
