//
//  TCAlertController.m
//  
//
//  Created by tanyang on 15/9/1.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TCAlertController.h"
#import "UIView+TCAutoLayout.h"
#import "UIView+TCAlertView.h"

@interface TCAlertController ()

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, assign) TCAlertControllerStyle preferredStyle;

@property (nonatomic, assign) TCAlertTransitionAnimation transitionAnimation;

@property (nonatomic, assign) Class transitionAnimationClass;

@property (nonatomic, weak)  UITapGestureRecognizer *singleTap;

@property (nonatomic, strong) NSLayoutConstraint *alertViewCenterYConstraint;

@property (nonatomic, assign) CGFloat alertViewCenterYOffset;

@end

@implementation TCAlertController

#pragma mark - init

- (instancetype)init
{
    if (self = [super init]) {
        [self configureController];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureController];
    }
    return self;
}

- (instancetype)initWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation transitionAnimationClass:(Class)transitionAnimationClass
{
    if (self = [self initWithNibName:nil bundle:nil]) {
        _alertView = alertView;
        _preferredStyle = preferredStyle;
        _transitionAnimation = transitionAnimation;
        _transitionAnimationClass = transitionAnimationClass;
    }
    return self;
}

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView
{
    return [[self alloc]initWithAlertView:alertView
                           preferredStyle:TCAlertControllerStyleAlert
                      transitionAnimation:TCAlertTransitionAnimationFade
                 transitionAnimationClass:nil];
}

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle
{
    return [[self alloc]initWithAlertView:alertView
                           preferredStyle:preferredStyle
                      transitionAnimation:TCAlertTransitionAnimationFade
                 transitionAnimationClass:nil];
}

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimation:(TCAlertTransitionAnimation)transitionAnimation
{
    return [[self alloc]initWithAlertView:alertView
                           preferredStyle:preferredStyle
                      transitionAnimation:transitionAnimation
                 transitionAnimationClass:nil];
}

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(TCAlertControllerStyle)preferredStyle transitionAnimationClass:(Class)transitionAnimationClass
{
    return [[self alloc]initWithAlertView:alertView
                           preferredStyle:preferredStyle
                      transitionAnimation:TCAlertTransitionAnimationCustom
                 transitionAnimationClass:transitionAnimationClass];
}

+ (instancetype)alertControllerWithTitle:(NSString*)title
                             cofirmBlock:(TCConfirmBlock)confirmBlock
                             cancelBlock:(TCCancelBlock)cancelBlock
{
    TCAlertController *ctrl = [TCAlertController alertControllerWithTitle:title
                              confirmButtonName:nil
                                    cofirmBlock:confirmBlock
                                    cancelBlock:cancelBlock];
    return ctrl;
}

+ (instancetype)alertControllerWithTitle:(NSString*)title
                       confirmButtonName:(NSString*)confirmBtnName
                             cofirmBlock:(TCConfirmBlock)confirmBlock
                             cancelBlock:(TCCancelBlock)cancelBlock
{
    TCConfirmView *view = [TCConfirmView createViewFromNib];
    view.confirmBlock = confirmBlock;
    view.cancelBlock = cancelBlock;
    view.text = title;
    if (confirmBtnName && confirmBtnName.length > 0)
    {
        view.confirmButtonName = confirmBtnName;
    }
    TCAlertController *controller = [[self alloc] initWithAlertView:view preferredStyle:TCAlertControllerStyleAlert transitionAnimation:TCAlertTransitionAnimationFade transitionAnimationClass:nil];
    controller.backgoundTapDismissEnable = NO;
    controller.alertViewCenterYOffset = -220;
    return controller;
}

+ (void) presentFromController:(UIViewController*)controller
                         title:(NSString*)title
             confirmButtonName:(NSString*)confirmBtnName
                  confirmBlock:(TCConfirmBlock)confirmBlock
                   cancelBlock:(TCCancelBlock)cancelBlock
{
    if (controller)
    {
        TCAlertController *ctrl = [TCAlertController alertControllerWithTitle:title
                                                            confirmButtonName:confirmBtnName
                                                                  cofirmBlock:confirmBlock
                                                                  cancelBlock:cancelBlock];
        [controller presentViewController:ctrl animated:YES completion:nil];
    }
}

+ (instancetype)alertControllerWithTitle:(NSString*)title
                                 okBlock:(TCOKBlock)okBlock
{
    TCOKView *view = [TCOKView createViewFromNib];
    view.okBlock = okBlock;
    view.text = title;
    TCAlertController *controller = [[self alloc] initWithAlertView:view preferredStyle:TCAlertControllerStyleAlert transitionAnimation:TCAlertTransitionAnimationFade transitionAnimationClass:nil];
    controller.backgoundTapDismissEnable = NO;
    return controller;
}

+ (void) presentFromController:(UIViewController*)controller
                         title:(NSString*)title
                       okBlock:(TCOKBlock)block
{
    if (controller)
    {
        TCAlertController *ctrl = [TCAlertController alertControllerWithTitle:title
                                                                      okBlock:block];
        [controller presentViewController:ctrl animated:YES completion:nil];
    }
}

+ (void) presentWithTitle:(NSString*)title okBlock:(TCOKBlock)block
{
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (rootVC)
    {
        [TCAlertController presentFromController:rootVC title:title okBlock:block];
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addBackgroundView];
    
    [self addSingleTapGesture];
    
    [self configureAlertView];
    
    [self.view layoutIfNeeded];
    
    if (_preferredStyle == TCAlertControllerStyleAlert) {
        // UIKeyboard Notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_viewWillShowHandler) {
        _viewWillShowHandler(_alertView);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_viewDidShowHandler) {
        _viewDidShowHandler(_alertView);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_viewWillHideHandler) {
        _viewWillHideHandler(_alertView);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_viewDidHideHandler) {
        _viewDidHideHandler(_alertView);
    }
}

- (void)addBackgroundView
{
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.backgroundColor = _backgroundColor;
        _backgroundView = backgroundView;
    }
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:_backgroundView atIndex:0];
    [self.view addConstraintToView:_backgroundView edgeInset:UIEdgeInsetsZero];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = backgroundView;
    } else if (_backgroundView != backgroundView) {
        backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view insertSubview:backgroundView aboveSubview:_backgroundView];
        [self.view addConstraintToView:backgroundView edgeInset:UIEdgeInsetsZero];
        backgroundView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [_backgroundView removeFromSuperview];
            _backgroundView = backgroundView;
            [self addSingleTapGesture];
        }];
    }
}

- (void)addSingleTapGesture
{
    self.view.userInteractionEnabled = YES;
    _backgroundView.userInteractionEnabled = YES;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = _backgoundTapDismissEnable;
  
    [_backgroundView addGestureRecognizer:singleTap];
    _singleTap = singleTap;
}

- (void)setBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    _backgoundTapDismissEnable = backgoundTapDismissEnable;
    _singleTap.enabled = backgoundTapDismissEnable;
}

#pragma mark - configure

- (void)configureController
{
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    _backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _backgoundTapDismissEnable = NO;
    _alertStyleEdging = 15;
    _actionSheetStyleEdging = 0;
}

- (void)configureAlertView
{
    if (_alertView == nil) {
        NSLog(@"%@: alertView is nil",NSStringFromClass([self class]));
        return;
    }
    _alertView.userInteractionEnabled = YES;
    [self.view addSubview:_alertView];
    _alertView.translatesAutoresizingMaskIntoConstraints = NO;
    switch (_preferredStyle) {
        case TCAlertControllerStyleActionSheet:
            [self layoutActionSheetStyleView];
            break;
        case TCAlertControllerStyleAlert:
            [self layoutAlertStyleView];
            break;
        default:
            break;
    }
}

- (void)configureAlertViewWidth
{
    // width, height
    if (!CGSizeEqualToSize(_alertView.frame.size,CGSizeZero)) {
        [_alertView addConstraintWidth:CGRectGetWidth(_alertView.frame) height:CGRectGetHeight(_alertView.frame)];
        
    }else {
        BOOL findAlertViewWidthConstraint = NO;
        for (NSLayoutConstraint *constraint in _alertView.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                findAlertViewWidthConstraint = YES;
                break;
            }
        }
        
        if (!findAlertViewWidthConstraint) {
            [_alertView addConstraintWidth:CGRectGetWidth(self.view.frame)-2*_alertStyleEdging height:0];
        }
    }
}

#pragma mark - layout 

- (void)layoutAlertStyleView
{
    // center X
    [self.view addConstraintCenterXToView:_alertView centerYToView:nil];
    
    [self configureAlertViewWidth];
    
    // top Y
    CGFloat verticalOffset = - self.view.frame.size.height * 0.05;
    _alertViewCenterYConstraint = [self.view addConstraintCenterYToView:_alertView constant:verticalOffset];
    
    if (_alertViewOriginY > 0) {
        [_alertView layoutIfNeeded];
        _alertViewCenterYOffset = _alertViewOriginY - (CGRectGetHeight(self.view.frame) - CGRectGetHeight(_alertView.frame))/2;
        _alertViewCenterYConstraint.constant = _alertViewCenterYOffset;
    }else{
        _alertViewCenterYOffset = 0;
    }
}

- (void)layoutActionSheetStyleView
{
    // remove width constaint
    for (NSLayoutConstraint *constraint in _alertView.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            [_alertView removeConstraint: constraint];
            break;
        }
    }
    
    // add edge constraint
    [self.view addConstraintWithView:_alertView topView:nil leftView:self.view bottomView:self.view rightView:self.view edgeInset:UIEdgeInsetsMake(0, _actionSheetStyleEdging, 0, -_actionSheetStyleEdging)];
    
    if (CGRectGetHeight(_alertView.frame) > 0) {
        // height
        [_alertView addConstraintWidth:0 height:CGRectGetHeight(_alertView.frame)];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)animated
{
    [self dismissViewControllerAnimated:YES completion:self.dismissComplete];
}

#pragma mark - action

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES];
}

#pragma mark - notification

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat alertViewBottomEdge = (CGRectGetHeight(self.view.frame) -  CGRectGetHeight(_alertView.frame))/2 - _alertViewCenterYOffset;
    
    //当开启热点时，向下偏移20px
    //修复键盘遮挡问题
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat differ = CGRectGetHeight(keyboardRect) - alertViewBottomEdge;

    //修复：输入框获取焦点时，会重复刷新，导致输入框文章偏移一下
    if (_alertViewCenterYConstraint.constant == -differ -statusBarHeight) {
        return;
    }
    
    if (differ >= 0) {
         _alertViewCenterYConstraint.constant = _alertViewCenterYOffset - differ - statusBarHeight;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}


- (void)keyboardWillHide:(NSNotification*)notification
{
    _alertViewCenterYConstraint.constant = _alertViewCenterYOffset;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
