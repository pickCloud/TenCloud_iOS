//
//  TCPermissionTableViewController.h
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCViewController.h"
#import "TCPermissionViewController.h"

@class TCPermissionNode;
@interface TCPermissionTableViewController : TCViewController

- (id) initWithPermissionNode:(TCPermissionNode*)node state:(PermissionVCState)state;

@end
