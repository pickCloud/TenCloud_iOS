//
//  TCConfirmView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCConfirmView;
typedef void (^TCConfirmBlock)(TCConfirmView *view);
typedef void (^TCCancelBlock)(TCConfirmView *view);

@interface TCConfirmView : UIView

@property (nonatomic, strong)   NSString    *text;
@property (nonatomic, strong)   NSString    *confirmButtonName;
@property (nonatomic, copy) TCConfirmBlock   confirmBlock;
@property (nonatomic, copy) TCCancelBlock    cancelBlock;

@end
