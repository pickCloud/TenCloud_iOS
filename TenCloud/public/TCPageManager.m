//
//  TCPageManager.m
//  TenCloud
//
//  Created by huangdx on 2018/1/24.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCPageManager.h"
#import "TCPersonHomeViewController.h"
#import "TCMessageManager.h"
#import "TCWelcomeViewController.h"
#import "TCTabBarController.h"
#import "TCLoginViewController.h"

typedef void (^TCRootVCAnimation)(void);

@implementation TCPageManager

+ (void) showPersonHomePageFromController:(UIViewController*)viewController
{
    if (viewController)
    {
        [[TCMessageManager shared] clearAllObserver];
        TCPersonHomeViewController *personVC = [[TCPersonHomeViewController alloc] init];
        [[TCCurrentCorp shared] setCid:0];
        NSString *localName = [[TCLocalAccount shared] name];
        [[TCCurrentCorp shared] setName:localName];
        [[TCCurrentCorp shared] save];
        NSMutableArray *newVCS = [NSMutableArray new];
        [newVCS addObject:personVC];
        [viewController.navigationController setViewControllers:newVCS];
    }
}

+ (void) enterHomePage
{
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
    [TCPageManager setRootController:rootVC];
}

+ (void) setRootController:(UIViewController *)controller
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    TCRootVCAnimation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        keyWindow.rootViewController = controller;
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:keyWindow
                      duration:0.9f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:animation
                    completion:nil];
}
@end
