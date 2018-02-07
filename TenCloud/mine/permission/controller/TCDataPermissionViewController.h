//
//  TCDataPermissionViewController.h
//  TenCloud
//
//  Created by huangdx on 2018/2/6.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCViewController.h"
#import "TCPermissionViewController.h"

@class TCPermissionNode;
@interface TCDataPermissionViewController : TCViewController

- (id) initWithPermissionNode:(TCPermissionNode*)node state:(PermissionVCState)state;

@end
