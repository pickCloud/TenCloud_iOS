//
//  TCLogHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/3/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCLogHomeViewController.h"

@interface TCLogHomeViewController ()

@end

@implementation TCLogHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日志/事件";
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

@end
