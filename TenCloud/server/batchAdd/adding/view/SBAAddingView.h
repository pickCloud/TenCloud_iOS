//
//  SBAAddingView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBAAddingView : UIView

- (void) setProgress:(CGFloat)progress
               total:(NSInteger)totalNum
             success:(NSInteger)sucNum
                fail:(NSInteger)failNum;

@end
