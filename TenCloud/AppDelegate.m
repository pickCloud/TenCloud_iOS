//
//  AppDelegate.m
//  TenCloud
//
//  Created by huangdx on 2017/12/5.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "AppDelegate.h"
#import "YTKNetworkConfig.h"
#import <AFNetworking/AFNetworking.h>
#import "TCTabBarController.h"
#import "VHLNavigation.h"
#import "TCLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"tc.sqlite"];
    [[YTKNetworkConfig sharedConfig] setBaseUrl:SERVER_URL_STRING];
    
    [UIColor vhl_setDefaultNavBarTintColor:THEME_TINT_COLOR];
    [UIColor vhl_setDefaultNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
    [UIColor vhl_setDefaultNavBackgroundColor:THEME_TINT_COLOR];
    [[UITextField appearance] setTintColor:THEME_TINT_COLOR];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];

    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenRect];
    UIViewController *rootVC = nil;
    if ([[TCLocalAccount shared] isLogin])
    {
        rootVC = [[TCTabBarController alloc] init];
    }else
    {
        UIViewController *loginVC = [TCLoginViewController new];
        rootVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
