//
//  TCShareViewController.m
//
//
//  Created by huangdx on 2017/10/21.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "TCShareViewController.h"
#import <MessageUI/MessageUI.h>
#import "TCShareManager.h"

@interface TCShareViewController () <MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong)   MFMessageComposeViewController  *messageVC;
@property (nonatomic, weak) IBOutlet    UIView      *darkBackgroundView;
@property (nonatomic, weak) IBOutlet    UIView      *contentView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *contentViewBottomConstraint;
- (IBAction) onCancelButton:(id)sender;
- (IBAction) onMessageButton:(id)sender;
- (IBAction) onQQButton:(id)sender;
- (IBAction) onWeixinButton:(id)sender;
- (void) dismiss;
@end

@implementation TCShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    // Do any additional setup after loading the view from its nib.
    self.darkBackgroundView.alpha = 0.0;
    self.contentViewBottomConstraint.constant = -kScreenHeight;
    
    _messageVC = [[MFMessageComposeViewController alloc] init];
    _messageVC.messageComposeDelegate = self;
    //[[[[_messageVC viewControllers] lastObject] navigationItem] setTitle:@"返回"];
    //[[[[[picker viewControllers] lastObject] navigationItem] rightBarButtonItem] setTitle:@"返回"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.darkBackgroundView addGestureRecognizer:tapGesture];

}

- (void) setContent:(NSString *)content
{
    _content = content;
    if (_content && _content.length > 0)
    {
        [[UIPasteboard generalPasteboard] setString:_content];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showContentView];
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

- (IBAction) onCancelButton:(id)sender
{
    [self dismiss];
}

- (IBAction) onMessageButton:(id)sender
{
    NSLog(@"on message button");
    //MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    //vc.body = @"测试";
    //vc.messageComposeDelegate = self;
    //vc.navigationBar.tintColor = [UIColor blackColor];
    //[self presentViewController:vc animated:YES completion:nil];
    _messageVC.body = _content;
    [self presentViewController:_messageVC animated:YES completion:nil];
}

- (IBAction) onQQButton:(id)sender
{
    NSLog(@"on qq button ");
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *iconPath = [[infoDict valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *icon = [UIImage imageNamed:iconPath];
    [[TCShareManager sharedManager] shareWithSharedType:TCShareTypeQQ
                                                  image:icon
                                                    url:_urlString
                                                content:_content
                                             controller:self];
    [self dismiss];
}

- (IBAction) onWeixinButton:(id)sender
{
    NSLog(@"on weixin button");
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *iconPath = [[infoDict valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage *icon = [UIImage imageNamed:iconPath];
    [[TCShareManager sharedManager] shareWithSharedType:TCShareTypeWechat
                                                  image:icon
                                                    url:_urlString
                                                content:_content
                                             controller:self];
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

#pragma mark - MFMessageComposeViewDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
    {
        [MBProgressHUD showError:@"取消发送" toView:nil];
    }else if(result == MessageComposeResultSent)
    {
        [MBProgressHUD showError:@"分享成功" toView:nil];
    }else {
        [MBProgressHUD showError:@"分享失败" toView:nil];
    }
}

@end
