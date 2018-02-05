//
//  TCOKView.h
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCOKView;
typedef void (^TCOKBlock)(TCOKView *view);

@interface TCOKView : UIView

@property (nonatomic, strong)   NSString    *text;
@property (nonatomic, copy) TCOKBlock   okBlock;

@end
