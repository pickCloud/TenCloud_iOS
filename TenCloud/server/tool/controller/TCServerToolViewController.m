//
//  TCServerOperateViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/12.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerToolViewController.h"

@interface TCServerToolViewController ()
@property (nonatomic, strong)   UIVisualEffectView      *effectView;
- (IBAction) onCloseButton:(id)sender;
- (IBAction) onRemoteAccessButton:(id)sender;
- (IBAction) onProcessStatusButton:(id)sender;
- (IBAction) onNetworkStatusButton:(id)sender;
- (IBAction) onRouteInfoButton:(id)sender;
- (IBAction) onPortInfoButton:(id)sender;
- (IBAction) onConfigManageButton:(id)sender;
- (IBAction) onMonitorFileButton:(id)sender;
@end

@implementation TCServerToolViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _effectView = [[UIVisualEffectView alloc] init];
    CGRect viewFrame = [[UIScreen mainScreen] bounds];
    _effectView.frame = viewFrame;
    _effectView.alpha = 0.72;
    [self.view addSubview:_effectView];
    [self.view sendSubviewToBack:_effectView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak __typeof(self) weakSelf = self;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView.effect = nil;
    [UIView animateWithDuration:1.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.effectView.effect = blur;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (IBAction) onCloseButton:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.72
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [weakSelf dismissViewControllerAnimated:NO completion:nil];
                     }];
    
}

- (IBAction) onRemoteAccessButton:(id)sender
{
    
}

- (IBAction) onProcessStatusButton:(id)sender
{
    
}

- (IBAction) onNetworkStatusButton:(id)sender
{
    
}

- (IBAction) onRouteInfoButton:(id)sender
{
    
}

- (IBAction) onPortInfoButton:(id)sender
{
    
}

- (IBAction) onConfigManageButton:(id)sender
{
    
}

- (IBAction) onMonitorFileButton:(id)sender
{
    
}

@end
