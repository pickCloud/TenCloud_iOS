//
//  TCServerHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerHomeViewController.h"
#import "TCPasswordLoginRequest.h"

@interface TCServerHomeViewController ()

@end

@implementation TCServerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务器";
    
    TCPasswordLoginRequest *loginReq = [[TCPasswordLoginRequest alloc] initWithPhoneNumber:@"18521316580" password:@"111111"];
    [loginReq startWithSuccess:^(NSString *token) {
        NSLog(@"登录成功:%@",token);
    } failure:^(NSString *message) {
        NSLog(@"fail:%@",message);
    }];
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
