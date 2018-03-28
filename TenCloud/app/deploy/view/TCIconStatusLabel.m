//
//  TCDeployStatusLabel.m
//  TenCloud
//
//  Created by huangdx on 2018/3/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCIconStatusLabel.h"

@implementation TCIconStatusLabel

- (void) initUI
{
    self.edgeInsets = UIEdgeInsetsMake(1, 15, 1, 2);
    self.layer.cornerRadius = 2.0;
    self.clipsToBounds = YES;
    self.backgroundColor = STATE_NORMAL_BG_COLOR;
    self.textColor = STATE_NORMAL_COLOR;
    
    CGRect iconRect = CGRectMake(0, 0, 10, 10);
    _iconView = [[UIImageView alloc] initWithFrame:iconRect];
    UIImage *icon = [UIImage imageNamed:@"app_status_green"];
    _iconView.image = icon;
    [self addSubview:_iconView];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize labelSize = self.frame.size;
    self.layer.cornerRadius = labelSize.height/2.0;
    
    CGRect iconRect = CGRectMake(0, 0, labelSize.height, labelSize.height);
    _iconView.frame = iconRect;
}

- (void) setStatus:(NSString *)status
{
    if (status == nil)
    {
        return;
    }
    [self setText:status];
    if ([status containsString:@"已停止"])
    {
        [self setTextColor:STATE_ALERT_COLOR];
        [self setBackgroundColor:STATE_ALERT_BG_COLOR];
    }else if([status containsString:@"异常"])
    {
        [self setTextColor:STATE_ERROR_COLOR];
        [self setBackgroundColor:STATE_ERROR_BG_COLOR];
    }else if([status containsString:@"初创建"])
    {
        [self setTextColor:STATE_CREATE_COLOR];
        [self setBackgroundColor:STATE_CREATE_BG_COLOR];
    }else
    {
        [self setTextColor:STATE_NORMAL_COLOR];
        [self setBackgroundColor:STATE_NORMAL_BG_COLOR];
    }
}
@end
