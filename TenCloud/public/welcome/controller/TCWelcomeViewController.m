//
//  TCWelcomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/2/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCWelcomeViewController.h"
#import "TCTabBarController.h"
#import "TCLoginViewController.h"

typedef void (^RootVCAnimation)(void);

@interface TCWelcomeViewController ()
@property (nonatomic, weak) IBOutlet    UIScrollView    *scrollView;
@property (nonatomic, weak) IBOutlet    UIImageView     *indicatorView;
@property (nonatomic, weak) IBOutlet    UIButton        *startButton;
- (IBAction) onStartButton:(id)sender;
@end

@implementation TCWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSInteger pageIndex = (int)scrollView.contentOffset.x/screenRect.size.width;
    NSString *indicatorImgName = [NSString stringWithFormat:@"welcome_ind%ld",pageIndex+1];
    UIImage *indicatorImg = [UIImage imageNamed:indicatorImgName];
    if (indicatorImg)
    {
        [_indicatorView setImage:indicatorImg];
    }
}


#pragma mark - extension
- (IBAction) onStartButton:(id)sender
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = nil;
    if ([[TCLocalAccount shared] isLogin])
    {
        rootVC = [[TCTabBarController alloc] init];
    }else
    {
        UIViewController *loginVC = [TCLoginViewController new];
        rootVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    rootVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    RootVCAnimation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        keyWindow.rootViewController = rootVC;
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:keyWindow
                      duration:0.9f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:animation
                    completion:nil];
}

@end
