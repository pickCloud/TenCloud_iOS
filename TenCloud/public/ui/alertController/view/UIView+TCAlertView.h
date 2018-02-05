//
//  UIView+TCAlertView.h
//  
//
//  Created by tanyang on 15/9/7.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCAlertController.h"
#import "TCShowAlertView.h"

@interface UIView (TCAlertView)

+ (instancetype)createViewFromNib;

+ (instancetype)createViewFromNibName:(NSString *)nibName;

- (UIViewController*)viewController;

#pragma mark - show in controller

- (void)showInController:(UIViewController *)viewController;

- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle;

// backgoundTapDismissEnable default NO
- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation;

- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

#pragma mark - show in window

- (void)showInWindow;

// backgoundTapDismissEnable default NO
- (void)showInWindowWithBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;

- (void)showInWindowWithOriginY:(CGFloat)OriginY;

- (void)showInWindowWithOriginY:(CGFloat)OriginY backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable;


#pragma mark - hide

// this will judge and call right method
- (void)hideView;

- (void)hideInController;

- (void)hideInWindow;

@end
