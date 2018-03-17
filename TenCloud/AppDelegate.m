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
#import "TCLoginViewController.h"
#import "TCShareManager.h"
#import "NSString+Extension.h"
#import "TCInviteLoginViewController.h"
#import "TCAcceptInviteViewController.h"
#import "TCMessageManager.h"
#import "TCWelcomeViewController.h"
#import <Bugly/Bugly.h>
#import "TCConfiguration.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if ONLINE_ENVIROMENT
    [Bugly startWithAppId:@"df4c8fb59b"];
#endif
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"tc.sqlite"];
    [[YTKNetworkConfig sharedConfig] setBaseUrl:SERVER_URL_STRING];
    [[TCShareManager sharedManager] registerAllPlatForms];
    [[TCMessageManager shared] start];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[TCConfiguration shared] getServerThreshold];
    
    [[UITextField appearance] setTintColor:THEME_TINT_COLOR];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    
    /*
     //disappear at iPhoneX
    UIImage *backButtonImage = [[UIImage imageNamed:@"public_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 0)
                                                                                           resizingMode:UIImageResizingModeTile];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    //参考自定义文字部分
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                         forBarMetrics:UIBarMetricsDefault];
     */

    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenRect];
    

     //normal code
    UIViewController *rootVC = nil;
    NSString *storedKey = [[NSUserDefaults standardUserDefaults] objectForKey:WELCOME_PAGE_KEY];
    if (!storedKey || ![storedKey isEqualToString:WELCOME_PAGE_KEY])
    {
        rootVC = [[TCWelcomeViewController alloc] init];
    }else
    {
        if ([[TCLocalAccount shared] isLogin])
        {
            rootVC = [[TCTabBarController alloc] init];
        }else
        {
            UIViewController *loginVC = [TCLoginViewController new];
            rootVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        }
    }
    self.window.rootViewController = rootVC;
    
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:THEME_TINT_COLOR];
    [WRNavigationBar wr_setDefaultNavBarTintColor:THEME_NAVBAR_TITLE_COLOR];
    [WRNavigationBar wr_setDefaultNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    [self.window makeKeyAndVisible];
    
    
    //set navigationbar back button
    /*
     //fail here
    UIImage *backBtnImg = [UIImage imageNamed:@"public_back"];
    [[UINavigationBar appearance] setBackIndicatorImage:backBtnImg];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backBtnImg];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    if(@available(iOS 11, *)) {
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateHighlighted];
        
    } else {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-60, -60) forBarMetrics:UIBarMetricsDefault];
    }
     */
    
    //nice code
    /*
    NSString *invokePath = @"tencloud://invite?code=1234abc";
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:invokePath];
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    NSArray *queryItems = urlComponents.queryItems;
    for (NSURLQueryItem *queryItem in queryItems)
    {
        [queryDict setObject:queryItem.value forKey:queryItem.name];
    }
     */
    
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"page created2:%@",url);
    NSString *hostName = url.host;
    NSDictionary *paramDict = [NSString paramDictFromURLQueryString:url.query];
    if ([hostName isEqualToString:@"invite"])
    {
        if (paramDict)
        {
            NSString *code = [paramDict objectForKey:@"code"];
            [[TCMessageManager shared] clearAllObserver];
            if ([[TCLocalAccount shared] isLogin])
            {
                TCAcceptInviteViewController *acceptVC = [[TCAcceptInviteViewController alloc] initWithCode:code];
                UINavigationController *acceptNav = [[UINavigationController alloc] initWithRootViewController:acceptVC];
                self.window.rootViewController = acceptNav;
                [self.window makeKeyAndVisible];
            }else
            {
                TCInviteLoginViewController *loginVC = [[TCInviteLoginViewController alloc] initWithCode:code];
                UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                self.window.rootViewController = loginNav;
                [self.window makeKeyAndVisible];
            }
        }
    }
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
