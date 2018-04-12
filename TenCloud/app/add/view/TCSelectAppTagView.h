//
//  TCSelectAppTagView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCSelectAppTagView;
typedef void (^TCSelectAppTagBlock)(TCSelectAppTagView *view,NSArray *tags);

@interface TCSelectAppTagView : UIView

- (void) setTagArray:(NSArray*)tagArray;

@property (nonatomic, copy)     TCSelectAppTagBlock   resultBlock;

@end
