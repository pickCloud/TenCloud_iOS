//
//  TCPageManager.m
//  TenCloud
//
//  Created by huangdx on 2018/1/24.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCPageManager.h"
#import "TCPersonHomeViewController.h"

@implementation TCPageManager

+ (void) showPersonHomePageFromController:(UIViewController*)viewController
{
    if (viewController)
    {
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
@end
