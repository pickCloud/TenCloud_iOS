//
//  TCIconStatusLabel.h
//  TenCloud
//
//  Created by huangdx on 2018/3/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCIconStatusLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) UIImageView   *iconView;

- (void) setStatus:(NSString*)status;

@end
