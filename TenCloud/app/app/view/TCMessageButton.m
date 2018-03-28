//
//  TCMessageButton.m
//  TenCloud
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCMessageButton.h"
#import "TCMessageManager.h"
#import "UIView+MGBadgeView.h"

@interface TCMessageButton()<TCMessageManagerDelegate>
@end

@implementation TCMessageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [super init];
    if (self)
    {
        UIImage *messageIconImg = [UIImage imageNamed:@"nav_message"];
        //_messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setImage:messageIconImg forState:UIControlStateNormal];
        [self sizeToFit];
        //[self addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger msgCount = [[TCMessageManager shared] count];
        [self.badgeView setBadgeValue:msgCount];
        [self.badgeView setOutlineWidth:0.0];
        [self.badgeView setBadgeColor:[UIColor redColor]];
        [self.badgeView setMinDiameter:18.0];
        [self.badgeView setPosition:MGBadgePositionTopRight];
        
        [[TCMessageManager shared] addObserver:self];
    }
    return self;
}

- (void) dealloc
{
    [[TCMessageManager shared] removeObserver:self];
}

#pragma mark - TCMessageManagerDelegate
- (void) messageCountChanged:(NSInteger)count
{
    self.badgeView.badgeValue = count;
}

@end
