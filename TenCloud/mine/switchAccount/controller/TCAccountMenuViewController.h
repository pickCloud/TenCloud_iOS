//
//  TCAccountMenuViewController.h
//  切换身份下拉菜单
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCAccountMenuViewController;
typedef void (^TCAccountMenuSelectBlock)(TCAccountMenuViewController *vc, NSInteger selectedIndex);

@interface TCAccountMenuViewController : UIViewController

- (instancetype) initWithCorpArray:(NSArray*)corpArray buttonRect:(CGRect)rect;
@property (nonatomic, copy) TCAccountMenuSelectBlock   selectBlock;

@end
