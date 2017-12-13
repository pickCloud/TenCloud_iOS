//
//  GetCaptchaButton.h
//  YE
//
//  Created by huangdx on 2017/10/26.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FetchCaptchaState){
    FetchCaptchaStateNone   =    0,          //未获取
    FetchCaptchaStateCountdown,              //倒计时
    FetchCaptchaStateRefetch,                //重新获取
};

@interface GetCaptchaButton : UIButton

@property (nonatomic, assign)   FetchCaptchaState     fetchState;

@end
