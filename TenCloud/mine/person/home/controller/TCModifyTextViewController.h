//
//  TCModifyTextViewController.h
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCViewController.h"

@class TCModifyTextViewController;
typedef void (^TCModifyTextValueChangedBlock)(TCModifyTextViewController *vc, id newValue);

@interface TCModifyTextViewController : TCViewController

@property (nonatomic, strong)   NSString    *titleText;
@property (nonatomic, strong)   NSString    *initialValue;
@property (nonatomic, copy) TCModifyTextValueChangedBlock   valueChangedBlock;

@end