//
//  TCShareViewController.m
//
//
//  Created by huangdx on 2017/10/21.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "TCShareViewController.h"

#define SELECT_GRADE_CELL_REUSE_ID      @"SELECT_GRADE_CELL_REUSE_ID"
#define SELECT_COURSE_CELL_REUSE_ID     @"SELECT_COURSE_CELL_REUSE_ID"



@interface TCShareViewController ()
@property (nonatomic, weak) IBOutlet    UIView      *darkBackgroundView;
@property (nonatomic, weak) IBOutlet    UIView      *contentView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *contentViewBottomConstraint;
@property (nonatomic, weak) IBOutlet    UIButton    *confirmButton;
@property (nonatomic, weak) IBOutlet    UICollectionView    *gradeCollectionView;
@property (nonatomic, weak) IBOutlet    UICollectionView    *courseCollectionView;
- (IBAction) onConfirmButton:(id)sender;
- (void) dismiss;
@end

@implementation TCShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.darkBackgroundView.alpha = 0.0;
    self.contentViewBottomConstraint.constant = -kScreenHeight;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.darkBackgroundView addGestureRecognizer:tapGesture];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showContentView];
}

- (void)viewDidLayoutSubviews
{
    CGFloat btnCornerRadius = _confirmButton.frame.size.height/2.0;
    _confirmButton.layer.cornerRadius = btnCornerRadius;
}


- (void) showContentView
{
    self.contentViewBottomConstraint.constant = - _contentView.frame.size.height;
    
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0.01 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        weakSelf.darkBackgroundView.alpha = 1.0;
        
        weakSelf.contentViewBottomConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    } completion:NULL];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (IBAction) onConfirmButton:(id)sender
{
    [self dismiss];
}

- (void) onTapGesture:(id)sender
{
    [self dismiss];
}

- (void) dismiss
{
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        weakSelf.contentViewBottomConstraint.constant = -_contentView.frame.size.height;
        weakSelf.darkBackgroundView.alpha = 0.0;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

@end
