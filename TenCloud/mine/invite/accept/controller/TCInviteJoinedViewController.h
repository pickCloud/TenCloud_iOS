//
//  TCInviteJoinedViewController.h
//  功能: 邀请加入页面(已经加入、审核中两种情况下显示)
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCViewController.h"

@interface TCInviteJoinedViewController : TCViewController

- (instancetype) initWithStaffStatus:(NSInteger)status corpID:(NSInteger)corpID;

@end
