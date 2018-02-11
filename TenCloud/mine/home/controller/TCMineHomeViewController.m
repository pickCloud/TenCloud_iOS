//
//  TCMineHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMineHomeViewController.h"
#import "TCLoginViewController.h"

//tmp
#import "TCSetSmsCountRequest.h"

@interface TCMineHomeViewController ()
- (IBAction) onLogout:(id)sender;
- (IBAction) onSetSmsCount4:(id)sender;
- (IBAction) onSetSmsCount0:(id)sender;
@end

@implementation TCMineHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) onLogout:(id)sender
{
    [[TCLocalAccount shared] logout];
    TCLoginViewController *loginVC = [TCLoginViewController new];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginNav];
}

- (IBAction) onSetSmsCount4:(id)sender
{
    TCSetSmsCountRequest *request = [[TCSetSmsCountRequest alloc] initWithCount:10];
    [request startWithSuccess:^(NSString *message) {
        NSLog(@"msg:%@",message);
    } failure:^(NSString *message) {
        NSLog(@"msg:%@",message);
    }];
}

- (IBAction) onSetSmsCount0:(id)sender
{
    TCSetSmsCountRequest *request = [[TCSetSmsCountRequest alloc] initWithCount:0];
    [request startWithSuccess:^(NSString *message) {
        NSLog(@"msg:%@",message);
    } failure:^(NSString *message) {
        NSLog(@"msg:%@",message);
    }];
}
@end
