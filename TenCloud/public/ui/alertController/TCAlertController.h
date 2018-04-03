//
//  TCAlertController.h
//  
//
//  Created by tanyang on 15/9/1.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCAlertView.h"
#import "TCConfirmView.h"
#import "TCOKView.h"


typedef NS_ENUM(NSInteger, TCAlertControllerStyle) {
    TCAlertControllerStyleAlert = 0,
    TCAlertControllerStyleActionSheet
};

typedef NS_ENUM(NSInteger, TCAlertTransitionAnimation) {
    TCAlertTransitionAnimationFade = 0,
    TCAlertTransitionAnimationScaleFade,
    TCAlertTransitionAnimationDropDown,
    TCAlertTransitionAnimationCustom
};


@interface TCAlertController : UIViewController

@property (nonatomic, strong, readonly) UIView *alertView;

@property (nonatomic, strong) UIColor *backgroundColor; // set backgroundColor
@property (nonatomic, strong) UIView *backgroundView; // you set coustom view to it

@property (nonatomic, assign, readonly) TCAlertControllerStyle preferredStyle;

@property (nonatomic, assign, readonly) TCAlertTransitionAnimation transitionAnimation;

@property (nonatomic, assign, readonly) Class transitionAnimationClass;

@property (nonatomic, assign) BOOL backgoundTapDismissEnable;  // default NO

@property (nonatomic, assign) CGFloat alertViewOriginY;  // default center Y

@property (nonatomic, assign) CGFloat alertStyleEdging; //  when width frame equal to 0,or no width constraint ,this proprty will use, default to 15 edge
@property (nonatomic, assign) CGFloat actionSheetStyleEdging; // default 0

// alertView lifecycle block
@property (copy, nonatomic) void (^viewWillShowHandler)(UIView *alertView);
@property (copy, nonatomic) void (^viewDidShowHandler)(UIView *alertView);
@property (copy, nonatomic) void (^viewWillHideHandler)(UIView *alertView);
@property (copy, nonatomic) void (^viewDidHideHandler)(UIView *alertView);

// dismiss controller completed block
@property (nonatomic, copy) void (^dismissComplete)(void);

- (instancetype)initWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation transitionAnimationClass:(Class)transitionAnimationClass;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation;

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimationClass:(Class)transitionAnimationClass;

+ (instancetype)alertControllerWithTitle:(NSString*)title
                             cofirmBlock:(TCConfirmBlock)confirmBlock
                             cancelBlock:(TCCancelBlock)cancelBlock;

+ (instancetype)alertControllerWithTitle:(NSString*)title
                       confirmButtonName:(NSString*)confirmBtnName
                             cofirmBlock:(TCConfirmBlock)confirmBlock
                             cancelBlock:(TCCancelBlock)cancelBlock;

+ (void) presentFromController:(UIViewController*)controller
                         title:(NSString*)title
             confirmButtonName:(NSString*)confirmBtnName
                  confirmBlock:(TCConfirmBlock)confirmBlock
                   cancelBlock:(TCCancelBlock)cancelBlock;

+ (instancetype)alertControllerWithTitle:(NSString*)title
                                 okBlock:(TCOKBlock)okBlock;
                               //alignment:(NSTextAlignment)alignment;

+ (instancetype)alertControllerWithTitle:(NSAttributedString*)attrTitle
                                 okBlock:(TCOKBlock)okBlock
                               alignment:(NSTextAlignment)alignment;

+ (void) presentFromController:(UIViewController*)controller
                         title:(NSString*)title
                       okBlock:(TCOKBlock)block;

+ (void) presentFromController:(UIViewController*)controller
                         title:(NSAttributedString*)attrTitle;

+ (void) presentWithTitle:(NSString*)title okBlock:(TCOKBlock)block;

+ (void) presentWithTitle:(NSString *)title
                     desc:(NSString *)desc;

- (void) present;

- (void)dismissViewControllerAnimated: (BOOL)animated;

@end

// Transition Animate
@interface TCAlertController (TransitionAnimate)<UIViewControllerTransitioningDelegate>

@end
