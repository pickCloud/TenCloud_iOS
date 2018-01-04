//
//  TCModifyTextViewController.h
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCViewController.h"
#import "TCCellData.h"

@class TCModifyTextViewController;
typedef void (^TCModifyTextValueChangedBlock)(TCModifyTextViewController *vc, id newValue);
typedef void (^TCModifyTextRequestBlock)(TCModifyTextViewController *vc, NSString *newValue);

@interface TCModifyTextViewController : TCViewController

@property (nonatomic, strong)   NSString    *titleText;
@property (nonatomic, strong)   NSString    *keyName;
@property (nonatomic, strong)   NSString    *initialValue;
@property (nonatomic, strong)   NSString    *placeHolder;
@property (nonatomic, assign)   TCApiType   apiType;
@property (nonatomic, assign)   NSInteger   cid;
@property (nonatomic, copy) TCModifyTextValueChangedBlock   valueChangedBlock;
@property (nonatomic, copy) TCModifyTextRequestBlock        requestBlock;

- (void) modifyRequestResult:(BOOL)isSuccess message:(NSString*)msg;

@end
