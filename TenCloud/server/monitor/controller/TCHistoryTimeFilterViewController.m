//
//  TCHistoryTimeFilterViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCHistoryTimeFilterViewController.h"
//#import "TCSearchFilterCollectionCell.h"
//#import "TCClusterProvider+CoreDataClass.h"
//#import "TCConfiguration.h"
//#import "JYEqualCellSpaceFlowLayout.h"

//#define SEARCH_FILTER_CELL_REUSE_ID     @"SEARCH_FILTER_CELL_REUSE_ID"

@interface TCHistoryTimeFilterViewController ()
@property (nonatomic, weak) IBOutlet    UIView      *darkBackgroundView;
@property (nonatomic, weak) IBOutlet    UIView      *contentView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *contentViewTrailingConstraint;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
//@property (nonatomic, weak) IBOutlet    UICollectionView    *providerView;
//@property (nonatomic, weak) IBOutlet    UICollectionView    *areaView;
- (IBAction) onConfirmButton:(id)sender;
- (void) dismiss;
@end

@implementation TCHistoryTimeFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.darkBackgroundView.alpha = 0.0;
    self.contentViewTrailingConstraint.constant = - kScreenWidth;
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 40 + 20;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.darkBackgroundView addGestureRecognizer:tapGesture];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.darkBackgroundView addGestureRecognizer:swipeGesture];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - extension
- (IBAction) onConfirmButton:(id)sender
{
    NSLog(@"on confirm button");
    
    [self dismiss];

}

- (void) dismiss
{
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        weakSelf.contentViewTrailingConstraint.constant = -_contentView.frame.size.width;
        weakSelf.darkBackgroundView.alpha = 0.0;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void) showContentView
{
    self.contentViewTrailingConstraint.constant = - _contentView.frame.size.width;
    
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0.01 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        weakSelf.darkBackgroundView.alpha = 1.0;
        
        weakSelf.contentViewTrailingConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    } completion:NULL];
    
}

- (void) onTapGesture:(id)sender
{
    [self dismiss];
}

@end
