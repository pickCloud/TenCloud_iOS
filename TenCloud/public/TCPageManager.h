//
//  TCPageManager.h
//  TenCloud
//
//  Created by huangdx on 2018/1/24.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCCorp;
@interface TCPageManager : NSObject

+ (void) showPersonHomePageFromController:(UIViewController*)viewController;

+ (void) enterHomePage;

+ (void) setRootController:(UIViewController*)controller;

+ (void) loadCorpPageWithCorpID:(NSInteger)corpID;

+ (void) loadCorpProfilePageWithCorp:(TCCorp*)corp;

+ (void) loadCorpStaffPage:(NSInteger)corpID;

@end
