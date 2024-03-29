//
//  TCSuccessResultViewController.h
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCViewController.h"

typedef void (^FinishBlock)(UIViewController *viewController);

@interface TCSuccessResultViewController : TCViewController

- (id) initWithTitle:(NSString *)title desc:(NSString*)desc;

@property (nonatomic, copy) FinishBlock     finishBlock;
@property (nonatomic, strong)   NSString    *buttonTitle;

@end
