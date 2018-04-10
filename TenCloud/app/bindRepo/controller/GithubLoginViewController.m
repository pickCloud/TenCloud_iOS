//
//  GithubLoginViewController.m
//  YE
//
//  Created by huangdx on 2017/11/5.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "GithubLoginViewController.h"
//#import <WebKit/WebKit.h>

@interface GithubLoginViewController ()
@property (nonatomic, weak) IBOutlet    UIWebView   *webView;
@end

@implementation GithubLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GitHub";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    NSString *urlStr = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&state=1&redirect_uri=%@",GITHUB_CLIENT_ID,GITHUB_CALLBACK];
    NSURL *eulaURL = [NSURL URLWithString:urlStr];
    NSLog(@"eula url:%@",eulaURL);
    NSURLRequest *eulaReq = [NSURLRequest requestWithURL:eulaURL];
    [_webView loadRequest:eulaReq];
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
