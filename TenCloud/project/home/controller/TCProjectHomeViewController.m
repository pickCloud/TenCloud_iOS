//
//  TCProjectHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCProjectHomeViewController.h"
#import "TCAlertController.h"
#import "TCConfirmView.h"

@interface TCProjectHomeViewController ()
- (IBAction) onAlertButton:(id)sender;
- (IBAction) onOkAlertButton:(id)sender;
@end

@implementation TCProjectHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"项目";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    [self wr_setNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) onAlertButton:(id)sender
{
    /*
    TCConfirmView *confirmView = [TCConfirmView createViewFromNib];
    confirmView.confirmBlock = ^(TCConfirmView *view) {
        NSLog(@"preset confirm block");
    };
    confirmView.cancelBlock = ^(TCConfirmView *view) {
        NSLog(@"preset cancel block");
    };
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:confirmView preferredStyle:TYAlertControllerStyleAlert];
    //alertController.alertViewOriginY = 200;
    //alertController.transitionAnimation = TYAlertTransitionAnimationDropDown;
    alertController.backgoundTapDismissEnable = NO;
    [self presentViewController:alertController animated:YES completion:nil];
     */
    TCAlertController *alertController = nil;
    alertController = [TCAlertController alertControllerWithTitle:@"确定删除这个文件吗?" cofirmBlock:^(TCConfirmView *view) {
        NSLog(@"非常肯定的删除");
    } cancelBlock:^(TCConfirmView *view) {
        NSLog(@"啊，还是不删了");
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction) onOkAlertButton:(id)sender
{
    TCAlertController *okController = nil;
    okController = [TCAlertController alertControllerWithTitle:@"您已经被踢出富豪榜" okBlock:^(TCOKView *view) {
        NSLog(@"踢就踢就呗");
    }];
    [self presentViewController:okController animated:YES completion:nil];
}
@end
