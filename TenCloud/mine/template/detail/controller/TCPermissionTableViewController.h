//
//  TCPermissionTableViewController.h
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "TCViewController.h"

@class TCPermissionSegment;
@interface TCPermissionTableViewController : TCViewController

- (id) initWithPermissionSegment:(TCPermissionSegment*)segment;

@end
