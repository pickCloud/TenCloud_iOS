//
//  TCShareManager.m
//  Forum
//
//  Created by hdx on 2017/7/16.
//  Copyright © 2017年 ksrsj.com. All rights reserved.
//

#import "TCShareManager.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentApiInterface.h>

#define WECHAT_APP_ID       @"wxc01464912319f82e"
#define WECHAT_APP_SECRET   @"a899820621ce623d835c4caf9381762d"
#define QQ_APP_ID           @"1106665152"
#define QQ_APP_KEY          @"slhcMjf52PvQoMnO"

static TCShareManager *_singleton = nil;

@implementation TCShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

- (void)registerAllPlatForms {
    
    [UMSocialData setAppKey:@"57cfeda567e58e275c00102d"];
    //设置微信AppId、appSecret，分享url
    [UMSocialData openLog:YES];
//    [UMSocialWechatHandler setWXAppId:@"wxc01464912319f82e" appSecret:@"a899820621ce623d835c4caf9381762d" url:@"http://c.10.com"];
//    [UMSocialQQHandler setQQWithAppId:@"1106665152" appKey:@"slhcMjf52PvQoMnO" url:@"http://c.10.com"];
    [UMSocialWechatHandler setWXAppId:WECHAT_APP_ID appSecret:WECHAT_APP_SECRET
                                  url:@"http://c.10.com"];
    [UMSocialQQHandler setQQWithAppId:QQ_APP_ID appKey:QQ_APP_KEY
                                  url:@"http://c.10.com"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

- (void)shareWithSharedType:(TCShareType)shareType
                      image:(UIImage *)image
                        url:(NSString *)url
                    content:(NSString *)content
                 controller:(UIViewController *)controller {
    switch (shareType) {
        case TCShareTypeWechatPengyouquan: {
            if (![WXApi isWXAppInstalled]) {
                [self showTip:@"未安装微信，请先安装"];
                return ;
            }
//            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:@"http://www.jianshu.com/users/3930920b505b/latest_articles"];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:content image:[UIImage imageNamed:@"digupicon_review_press_1"] location:nil urlResource:resource presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self shareSucceed];
                    NSLog(@"分享成功！");
                }
            }];
        } break;
        case TCShareTypeWechat: {
            if (![WXApi isWXAppInstalled]) {
                [self showTip:@"未安装微信，请先安装"];
                return ;
            }
        
            /*
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:nil urlResource:resource presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self shareSucceed];
                    NSLog(@"分享成功！");
                }
            }];
             */
            [UMSocialWechatHandler setWXAppId:WECHAT_APP_ID appSecret:WECHAT_APP_SECRET
                                          url:url];
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:url];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:content image:nil location:nil urlResource:resource presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self shareSucceed];
                    NSLog(@"分享成功！");
                }
            }];
            
        }  break;
        case TCShareTypeWeibo: {
            if (![WeiboSDK isWeiboAppInstalled]) {
//                [MBProgressHUD showMessage:@"微博没有安装,请先安装微博" toView:controller.view];
                return ;
            }
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image location:nil urlResource:resource presentedController:controller completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    [self shareSucceed];
                    NSLog(@"分享成功！");
                }
            }];
        } break;
        case TCShareTypeQQ: {
            if (![TencentApiInterface isTencentAppInstall:kIphoneQQ]) {
                [self showTip:@"未安装QQ,请先安装"];
                return ;
            }
            //[UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            [UMSocialQQHandler setQQWithAppId:QQ_APP_ID appKey:QQ_APP_KEY
                                          url:url];
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:url];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:nil location:nil urlResource:resource presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self shareSucceed];
                    NSLog(@"分享成功！");
                }
            }];
        } break;
        case TCShareTypeQZone: {
            if (![TencentApiInterface isTencentAppInstall:kIphoneQQ]) {
                [self showTip:@"未安装QQ,请先安装"];
                return ;
            }
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
            [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:resource presentedController:controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [self shareSucceed];
                    NSLog(@"分享成功！");
                }
            }];
        } break;
        default:
            break;
    }
    image = nil;
}

- (void) showTip:(NSString*)tip
{
    UIAlertController *alertController = nil;
    alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                          message:tip
                                                   preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [rootVC presentViewController:alertController animated:YES completion:nil];
}

- (void)shareSucceed {
    
}

@end
