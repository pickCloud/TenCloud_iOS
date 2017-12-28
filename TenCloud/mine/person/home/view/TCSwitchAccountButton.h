//
//  TCSwitchAccountButton.h
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonTouchedBlock)();

@interface TCSwitchAccountButton : UIButton

@property (nonatomic, assign)   BOOL    checked;
@property (nonatomic, copy) ButtonTouchedBlock  touchedBlock;

@end
