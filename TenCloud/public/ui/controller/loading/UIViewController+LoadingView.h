//
//  UIViewController+LoadingView.h
//  AppModel
//
//  Created by huangdx on 2017/10/9.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoadingView)

- (void) startLoading;

- (void) stopLoading;

- (BOOL) isLoading;

@end
