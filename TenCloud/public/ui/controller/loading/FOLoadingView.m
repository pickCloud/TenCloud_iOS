//
//  FOLoadingView.m
//  AppModel
//
//  Created by huangdx on 2017/10/9.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "FOLoadingView.h"

@interface FOLoadingView ()
@property (nonatomic, weak) IBOutlet    UIImageView    *imageView;
@end

@implementation FOLoadingView

+ (instancetype) createWithFrame:(CGRect)frame
{
    FOLoadingView *loadingView =  [[[NSBundle mainBundle] loadNibNamed:@"FOLoadingView" owner:self options:nil] firstObject];
    loadingView.frame = frame;
    return loadingView;
}

- (void) startLoadingAnimation
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.28;//0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    [_imageView.layer addAnimation:animation forKey:@"rotation"];
    /*
    NSMutableArray  *imgArray = [NSMutableArray array];
    for (int i = 1; i <= 24; i++)
    {
        NSString *imgName = [NSString stringWithFormat:@"%d",i];
        UIImage *img = [UIImage imageNamed:imgName];
        [imgArray addObject:img];
    }
    self.imageView.animationImages = imgArray;
    self.imageView.animationRepeatCount = 0;
    self.imageView.animationDuration = 2.4;
    [self.imageView startAnimating];
     */
}

- (void) stopLoadingAnimation
{
    [_imageView.layer removeAllAnimations];
    /*
    [_imageView stopAnimating];
     */
     
}

@end
