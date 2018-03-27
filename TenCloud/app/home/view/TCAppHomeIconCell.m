//
//  TCAppHomeIconCell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAppHomeIconCell.h"

@interface TCAppHomeIconCell()
@property (nonatomic, weak) IBOutlet    UILabel     *amountLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIView      *bgView1;
@property (nonatomic, weak) IBOutlet    UIView      *bgView2;
@end

@implementation TCAppHomeIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView1.clipsToBounds = YES;
    _bgView2.clipsToBounds = YES;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    CGSize bgSize1 = _bgView1.bounds.size;
    _bgView1.layer.cornerRadius = bgSize1.width / 2.0;
    CGSize bgSize2 = _bgView2.bounds.size;
    _bgView2.layer.cornerRadius = bgSize2.width / 2.0;
}

- (void) setName:(NSString*)name withAmount:(NSInteger)amount
{
    _nameLabel.text = name;
    NSString *amountStr = [NSString stringWithFormat:@"%ld",amount];
    _amountLabel.text = amountStr;
}

@end
