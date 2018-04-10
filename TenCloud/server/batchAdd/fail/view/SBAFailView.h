//
//  SBAFailView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBAFailView;
typedef void (^SBAFailCancelBlock)(SBAFailView *view);
typedef void (^SBAFailRetryBlock)(SBAFailView *view);

@interface SBAFailView : UIView

- (void) setTotalAmount:(NSInteger)total
                success:(NSInteger)success
                   fail:(NSInteger)fail;
@property (nonatomic, strong)   NSString    *confirmButtonName;
@property (nonatomic, copy) SBAFailRetryBlock     retryBlock;
@property (nonatomic, copy) SBAFailCancelBlock    cancelBlock;

@end
