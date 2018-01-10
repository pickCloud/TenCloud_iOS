//
//  TCShareManager.h
//  Forum
//
//  Created by hdx on 2017/7/16.
//  Copyright © 2017年 ksrsj.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  三方类型
 */
typedef NS_ENUM(NSUInteger, TCShareType) {
    /** QQ*/
    TCShareTypeQQ = 1,
    /** QQ空间*/
    TCShareTypeQZone,
    /** 微信会话*/
    TCShareTypeWechatPengyouquan,
    /** 微信朋友圈*/
    TCShareTypeWechat,
    /** 微博*/
    TCShareTypeWeibo,
};
@interface TCShareManager : NSObject

+ (instancetype)sharedManager;

- (void)shareWithSharedType:(TCShareType)shareType
                      image:(UIImage *)image
                        url:(NSString *)url
                    content:(NSString *)content
                 controller:(UIViewController *)controller;

- (void)registerAllPlatForms;

@end
