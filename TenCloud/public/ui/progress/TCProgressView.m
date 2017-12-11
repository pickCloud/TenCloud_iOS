//
//  TCProgressView.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCProgressView.h"

#define PROGRESS_BG_COLOR       [UIColor colorWithRed:63/255.0 green:70/255.0 blue:86/255.0 alpha:1.0]
#define PROGRESS_NORMAL_COLOR   [UIColor colorWithRed:72/255.0 green:187/255.0 blue:192/255.0 alpha:1.0]
#define PROGRESS_DANGER_COLOR   [UIColor colorWithRed:241/255.0 green:85/255.0 blue:50/255.0 alpha:1.0]

@interface TCProgressView()
@property (nonatomic, strong)   UIView  *foreView;
@end

@implementation TCProgressView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        CGRect totalRect = self.bounds;
        //totalRect.size.width = 0.0;
        self.backgroundColor = PROGRESS_BG_COLOR;
        _foreView = [[UIView alloc] initWithFrame:totalRect];
        [self addSubview:_foreView];
        [_foreView setBackgroundColor:PROGRESS_NORMAL_COLOR];
    }
    return self;
}

- (void) setProgress:(CGFloat)progress
{
    CGRect totalRect = self.bounds;
    CGFloat progressWidth = totalRect.size.width * progress;
    CGRect progressRect = totalRect;
    progressRect.size.width = progressWidth;
    NSLog(@"progress width:%.2f",progressWidth);
    _foreView.frame = progressRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
