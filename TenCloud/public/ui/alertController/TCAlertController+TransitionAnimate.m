//
//  TCAlertController+TransitionAnimate.m
//  
//
//  Created by tanyang on 15/9/1.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TCAlertController.h"
#import "TCAlertFadeAnimation.h"
#import "TCAlertScaleFadeAnimation.h"
#import "TCAlertDropDownAnimation.h"

@implementation TCAlertController (TransitionAnimate)

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    switch (self.transitionAnimation) {
        case TCAlertTransitionAnimationFade:
            return [TCAlertFadeAnimation alertAnimationIsPresenting:YES];
        case TCAlertTransitionAnimationScaleFade:
            return [TCAlertScaleFadeAnimation alertAnimationIsPresenting:YES];
        case TCAlertTransitionAnimationDropDown:
            return [TCAlertDropDownAnimation alertAnimationIsPresenting:YES];
        case TCAlertTransitionAnimationCustom:
            return [self.transitionAnimationClass alertAnimationIsPresenting:YES preferredStyle:self.preferredStyle];
        default:
            return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    switch (self.transitionAnimation) {
        case TCAlertTransitionAnimationFade:
            return [TCAlertFadeAnimation alertAnimationIsPresenting:NO];
        case TCAlertTransitionAnimationScaleFade:
            return [TCAlertScaleFadeAnimation alertAnimationIsPresenting:NO];
        case TCAlertTransitionAnimationDropDown:
            return [TCAlertDropDownAnimation alertAnimationIsPresenting:NO];
        case TCAlertTransitionAnimationCustom:
            return [self.transitionAnimationClass alertAnimationIsPresenting:NO preferredStyle:self.preferredStyle];
        default:
            return nil;
    }
}

@end
