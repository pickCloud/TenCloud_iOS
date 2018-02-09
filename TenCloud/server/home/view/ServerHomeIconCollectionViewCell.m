//
//  ServerHomeIconCollectionViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "ServerHomeIconCollectionViewCell.h"

@interface ServerHomeIconCollectionViewCell()
@property (nonatomic, weak) IBOutlet    UIImageView     *iconView;
@property (nonatomic, weak) IBOutlet    UILabel         *messageNumLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *titleLabel;
@end

@implementation ServerHomeIconCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void) setTitle:(NSString*)title icon:(NSString*)iconName messageNumber:(NSInteger)msgNumber
{
    NSString *msgNumberStr = [NSString stringWithFormat:@"%ld",msgNumber];
    _messageNumLabel.text = msgNumberStr;
    UIImage *iconImage = [UIImage imageNamed:iconName];
    _iconView.image = iconImage;
    _titleLabel.text = title;
    if (msgNumber == 0)
    {
        _messageNumLabel.backgroundColor = THEME_PLACEHOLDER_COLOR;
    }else
    {
        _messageNumLabel.backgroundColor = THEME_TINT_COLOR;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize messageLabelSize = _messageNumLabel.frame.size;
    _messageNumLabel.layer.cornerRadius = messageLabelSize.height / 2.0;
    _messageNumLabel.clipsToBounds = YES;
}

@end
