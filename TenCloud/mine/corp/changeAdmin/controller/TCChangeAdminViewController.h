//
//  TCChangeAdminViewController.h
//  更换管理员页面
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCViewController.h"


@class TCTemplate;
@class TCStaff;
@interface TCChangeAdminViewController : TCViewController

@property (nonatomic, strong)   NSMutableArray     *staffArray;
@property (nonatomic, strong)   TCStaff            *currentStaff;
@end
