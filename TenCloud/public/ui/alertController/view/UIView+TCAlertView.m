//
//  UIView+TCAlertView.m
//  
//
//  Created by tanyang on 15/9/7.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "UIView+TCAlertView.h"

@implementation UIView (TCAlertView)

+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - show in window

- (void)showInWindow
{
    [self showInWindowWithBackgoundTapDismissEnable:NO];
}

- (void)showInWindowWithBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [TCShowAlertView showAlertViewWithView:self backgoundTapDismissEnable:backgoundTapDismissEnable];
}

- (void)showInWindowWithOriginY:(CGFloat)OriginY
{
    [self showInWindowWithOriginY:OriginY backgoundTapDismissEnable:NO];
}

- (void)showInWindowWithOriginY:(CGFloat)OriginY backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [TCShowAlertView showAlertViewWithView:self originY:OriginY backgoundTapDismissEnable:backgoundTapDismissEnable];
}

- (void)hideInWindow
{
    if ([self isShowInWindow]) {
        [(TCShowAlertView *)self.superview hide];
    }else {
        NSLog(@"self.superview is nil, or isn't TYShowAlertView");
    }
}

#pragma mark - show in controller

- (void)showInController:(UIViewController *)viewController
{
    [self showInController:viewController preferredStyle:TCAlertControllerStyleAlert transitionAnimation:TCAlertTransitionAnimationFade];
}

- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle
{
    [self showInController:viewController preferredStyle:preferredStyle transitionAnimation:TCAlertTransitionAnimationFade];
}

- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    [self showInController:viewController preferredStyle:preferredStyle transitionAnimation:TCAlertTransitionAnimationFade backgoundTapDismissEnable:backgoundTapDismissEnable];
}

- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation
{
    [self showInController:viewController preferredStyle:preferredStyle transitionAnimation:transitionAnimation backgoundTapDismissEnable:NO];
}

- (void)showInController:(UIViewController *)viewController preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation backgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    TCAlertController *alertController = [TCAlertController alertControllerWithAlertView:self preferredStyle:preferredStyle transitionAnimation:transitionAnimation];
    alertController.backgoundTapDismissEnable = backgoundTapDismissEnable;
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)hideInController
{
    if ([self isShowInAlertController]) {
        [(TCAlertController *)self.viewController dismissViewControllerAnimated:YES];
    }else {
        NSLog(@"self.viewController is nil, or isn't TCAlertController");
    }
}

#pragma mark - hide

- (BOOL)isShowInAlertController
{
    UIViewController *viewController = self.viewController;
    if (viewController && [viewController isKindOfClass:[TCAlertController class]]) {
        return YES;
    }
    return NO;
    
}

- (BOOL)isShowInWindow
{
    if (self.superview && [self.superview isKindOfClass:[TCShowAlertView class]]) {
        return YES;
    }
    return NO;
}

- (void)hideView
{
    if ([self isShowInAlertController]) {
        [self hideInController];
    }else if ([self isShowInWindow]) {
        [self hideInWindow];
    }else {
        NSLog(@"self.viewController is nil, or isn't TCAlertController,or self.superview is nil, or isn't TCShowAlertView");
    }
}

@end
