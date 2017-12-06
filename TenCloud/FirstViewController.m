//
//  FirstViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/5.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "FirstViewController.h"
#import "TCPasswordLoginRequest.h"
#import "TCGetCaptchaRequest.h"
#import "TCRegisterRequest.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    [TCPasswordLoginRequest requestWithPhoneNumber:@"18521316580"
                                          password:@"111111"
                                           success:^(NSString *token) {
                                               NSLog(@"登录成功:%@",token);
                                           } failure:^(NSString *message) {
                                               NSLog(@"fail:%@",message);
                                           }];
     */
    
    /*
     [loginReq startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
     
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
     
     }];
     */
    
    /*
    //ok
    TCPasswordLoginRequest *loginReq = [[TCPasswordLoginRequest alloc] initWithPhoneNumber:@"18521316580" password:@"111111"];
    [loginReq startWithSuccess:^(NSString *token) {
        NSLog(@"登录成功:%@",token);
    } failure:^(NSString *message) {
        NSLog(@"fail:%@",message);
    }];
     */
    
    /*
    //ok
    TCGetCaptchaRequest *request = [[TCGetCaptchaRequest alloc] initWithPhoneNumber:@"18521316580"];
    [request startWithSuccess:^(NSString *message) {
        NSLog(@"suc msg:%@",message);
    } failure:^(NSString *message) {
        NSLog(@"fail msg:%@",message);
    }];
     */
    TCRegisterRequest *requet = [[TCRegisterRequest alloc] initWithPhoneNumber:@"18800000001"
                                                                      password:@"111111"
                                                                       captcha:@"111111"];
    [requet startWithSuccess:^(NSString *message) {
        NSLog(@"suc msg:%@",message);
    } failure:^(NSString *message) {
        NSLog(@"fail msg:%@",message);
    }];
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
