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
#import "TCCurrentCorp.h"
#import "TCCorpHomeViewController.h"
#import "TCCorp+CoreDataClass.h"
#import "TCCorpProfileViewController.h"
#import "TCStaffTableViewController.h"

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

+ (void) loadCorpPageWithCorpID:(NSInteger)corpID
{
    [[TCCurrentCorp shared] setCid:corpID];
    UITabBarController *tabController = (UITabBarController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (tabController)
    {
        NSArray *navControllers = tabController.viewControllers;
        if (navControllers && navControllers.count >= 5 )
        {
            [tabController setSelectedIndex:4];
            NSMutableArray *newVCS = [NSMutableArray new];
            TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:corpID];
            [newVCS addObject:homeVC];
            UINavigationController *nav = [navControllers objectAtIndex:4];
            [nav setViewControllers:newVCS animated:YES];
        }
    }
    //NSArray *navControllers = [[[UIApplication sharedApplication] keyWindow] rootViewController] childViewControllers
    /*
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
    [newVCS removeAllObjects];
    TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:cid];
    [newVCS addObject:homeVC];
    [weakSelf.navigationController setViewControllers:newVCS animated:YES];
     */
}

+ (void) loadCorpProfilePageWithCorp:(TCCorp*)corp
{
    [[TCCurrentCorp shared] setCid:corp.cid];
    UITabBarController *tabController = (UITabBarController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (tabController)
    {
        NSArray *navControllers = tabController.viewControllers;
        if (navControllers && navControllers.count >= 5 )
        {
            [tabController setSelectedIndex:4];
            NSMutableArray *newVCS = [NSMutableArray new];
            TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:corp.cid];
            [newVCS addObject:homeVC];
            TCCorpProfileViewController *profileVC = [[TCCorpProfileViewController alloc] initWithCorp:corp];
            [newVCS addObject:profileVC];
            UINavigationController *nav = [navControllers objectAtIndex:4];
            [nav setViewControllers:newVCS animated:YES];
        }
    }
}

+ (void) loadCorpStaffPage:(NSInteger)corpID
{
    [[TCCurrentCorp shared] setCid:corpID];
    UITabBarController *tabController = (UITabBarController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (tabController)
    {
        NSArray *navControllers = tabController.viewControllers;
        if (navControllers && navControllers.count >= 5 )
        {
            [tabController setSelectedIndex:4];
            NSMutableArray *newVCS = [NSMutableArray new];
            TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:corpID];
            [newVCS addObject:homeVC];
            TCStaffTableViewController *staffVC = [TCStaffTableViewController new];
            [newVCS addObject:staffVC];
            UINavigationController *nav = [navControllers objectAtIndex:4];
            [nav setViewControllers:newVCS animated:YES];
        }
    }
}
@end
