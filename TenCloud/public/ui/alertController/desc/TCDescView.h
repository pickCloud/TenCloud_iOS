//
//  TCDescView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCDescView;
typedef void (^TCDescOkBlock)(TCDescView *view);

@interface TCDescView : UIView

@property (nonatomic, strong)   NSString    *title;
@property (nonatomic, strong)   NSString    *desc;
@property (nonatomic, strong)   NSAttributedString  *attrText;
@property (nonatomic, copy) TCDescOkBlock   okBlock;
@property (nonatomic, assign)   NSTextAlignment alignment;

@end
