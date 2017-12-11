//
//  UIViewController+LoadingView.m
//  AppModel
//
//  Created by huangdx on 2017/10/9.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "UIViewController+LoadingView.h"
#import "FOLoadingView.h"

static char const * const kLoadingViewKey   =   "loadingViewKey";
static char const * const kIsLoadingKey     =   "isLoadingKey";

@implementation UIViewController (LoadingView)

- (FOLoadingView *) loadingView
{
    FOLoadingView *view = objc_getAssociatedObject(self, kLoadingViewKey);
    if (!view)
    {
        CGRect viewRect = self.view.bounds;
        //CGRect viewFrame = self.view.frame;
        FOLoadingView *newView = [FOLoadingView createWithFrame:viewRect];
        [self setLoadingView:newView];
    }
    return view;
}

- (void) setLoadingView:(FOLoadingView *)aLoadingView
{
    objc_setAssociatedObject(self, kLoadingViewKey, aLoadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) startLoading
{
    CGRect rect = self.view.bounds;
    NSLog(@"start loading rect:%2.f,%.2f",rect.size.width, rect.size.height);
    [self.loadingView removeFromSuperview];
    //[self.loadingView setBackgroundColor:[UIColor lightGrayColor]];
    UIColor *backgroundColor = self.view.backgroundColor;
    [self.loadingView setBackgroundColor:backgroundColor];
    [self.view addSubview:self.loadingView];
    [self.loadingView startLoadingAnimation];
    objc_setAssociatedObject(self, kIsLoadingKey, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) stopLoading
{
    [self.loadingView stopLoadingAnimation];
    [self.loadingView removeFromSuperview];
    objc_setAssociatedObject(self, kIsLoadingKey, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) isLoading
{
    NSNumber *loadingNum = objc_getAssociatedObject(self, kIsLoadingKey);
    return loadingNum.boolValue;
}
/*
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"vc_loading_did_appear");
    CGRect rect = self.view.bounds;
    NSLog(@"start loading rect3:%2.f,%.2f",rect.size.width, rect.size.height);
}
*/

//不合理,需要改正这个方法
- (void)viewDidLayoutSubviews
{
    CGRect rect = self.view.bounds;
    [self.loadingView setFrame:rect];
}
 
@end
