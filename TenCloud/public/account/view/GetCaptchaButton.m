//
//  GetCaptchaButton.m
//  YE
//
//  Created by huangdx on 2017/10/26.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "GetCaptchaButton.h"

@interface GetCaptchaButton()
@property (nonatomic, assign)   long    mCountDownNum;
- (void) doCountDown;
@end

@implementation GetCaptchaButton

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //_fetchState = FetchCaptchaStateNone;
        [self setFetchState:FetchCaptchaStateNone];
    }
    return self;
}

- (void)setNeedsDisplay
{
    //self.layer.borderWidth = 0.6;
    //self.layer.borderColor = THEME_TINT_COLOR.CGColor;
    //CGSize btnSize = self.frame.size;
    self.layer.cornerRadius = TCSCALE(4); //btnSize.height / 2.0;
    self.clipsToBounds = NO;
}

- (void) setFetchState:(FetchCaptchaState)fetchState
{
    _fetchState = fetchState;
    if ((_fetchState == FetchCaptchaStateNone)||
        (_fetchState == FetchCaptchaStateRefetch))
    {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        UIColor *bgColor = [THEME_TINT_COLOR colorWithAlphaComponent:0.3];
        //self.layer.borderColor = THEME_TINT_COLOR.CGColor;
        [self setBackgroundColor:bgColor];
        [self setTitleColor:THEME_TINT_COLOR forState:UIControlStateNormal];
        [self setUserInteractionEnabled:YES];
    }else if(_fetchState == FetchCaptchaStateCountdown)
    {
        _mCountDownNum = 60;
        [self setTitle:@"重新获取(60)" forState:UIControlStateNormal];
        //self.layer.borderColor = THEME_TEXT_COLOR.CGColor;
        UIColor *bgColor = [THEME_TEXT_COLOR colorWithAlphaComponent:0.3];
        [self setBackgroundColor:bgColor];
        [self setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        [self setUserInteractionEnabled:NO];
        [self doCountDown];
    }
}

- (void) doCountDown
{
    if (_mCountDownNum <= 0)
    {
        [self setFetchState:FetchCaptchaStateRefetch];
    }else
    {
        NSString *btnTitle = [NSString stringWithFormat:@"重新获取(%02ld)",_mCountDownNum];
        [self setTitle:btnTitle forState:UIControlStateNormal];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doCountDown) userInfo:nil repeats:NO];
        _mCountDownNum --;
    }
}

@end
