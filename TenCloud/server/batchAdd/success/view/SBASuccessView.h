//
//  SBASuccessView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBASuccessView;
typedef void (^SBASuccessBlock)(SBASuccessView *view);

@interface SBASuccessView : UIView

@property (nonatomic, assign)   NSInteger         importServerAmount;
@property (nonatomic, copy)     SBASuccessBlock   successBlock;

@end
