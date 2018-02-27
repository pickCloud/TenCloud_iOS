//
//  TCFilePermTableViewController.h
//  功能:权限编辑页面数据分页 文件列表页面
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCViewController.h"
#import "TCPermissionViewController.h"

@class TCPermissionNode;
@interface TCFilePermTableViewController : TCViewController

- (id) initWithPermissionNode:(TCPermissionNode*)node state:(PermissionVCState)state;

@end
