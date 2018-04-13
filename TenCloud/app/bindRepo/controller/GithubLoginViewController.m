//
//  GithubLoginViewController.m
//  YE
//
//  Created by huangdx on 2017/11/5.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "GithubLoginViewController.h"
//#import <WebKit/WebKit.h>

@interface GithubLoginViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet    UIWebView   *webView;
@end

@implementation GithubLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GitHub";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    NSURL *eulaURL = [NSURL URLWithString:_loginURLString];
    NSURLRequest *eulaReq = [NSURLRequest requestWithURL:eulaURL];
    [_webView setDelegate:self];
    [_webView loadRequest:eulaReq];
    
    
    //http://47.75.159.100/?token=true
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

#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
    //NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //NSLog(@"start load title:%@",title);
    NSString *urlStr = webView.request.URL.absoluteString;
    NSString *successAddr = [NSString stringWithFormat:@"%@/?token=true",SERVER_URL_STRING];
    if ([urlStr hasPrefix:successAddr])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GITHUB_LOGIN_SUCCESS object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //NSLog(@"webViewDidStartLoad = %@",webView.request.URL.absoluteString);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"webViewDidFinishLoad = %@",webView.request.URL.absoluteString);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //NSLog(@"didFailLoadWithError error = %@",error);
}
@end
