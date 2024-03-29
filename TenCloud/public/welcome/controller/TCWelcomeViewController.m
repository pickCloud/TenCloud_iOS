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
#import "TCPageManager.h"

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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:WELCOME_PAGE_KEY forKey:WELCOME_PAGE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    UIViewController *rootVC = nil;
    if ([[TCLocalAccount shared] isLogin])
    {
        rootVC = [[TCTabBarController alloc] init];
    }else
    {
        UIViewController *loginVC = [TCLoginViewController new];
        rootVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    [TCPageManager setRootController:rootVC];
}

@end
