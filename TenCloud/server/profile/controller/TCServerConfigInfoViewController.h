//
//  TCServerConfigInfoViewController.h
//  功能: 配置信息页面
//
//  Created by huangdx on 2018/3/16.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCViewController.h"

//@class TCServerSystemConfig;
@class TCServerConfig;
@interface TCServerConfigInfoViewController : TCViewController

- (id) initWithConfig:(TCServerConfig*)config;

@end
