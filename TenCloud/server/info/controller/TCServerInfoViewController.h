//
//  TCServerInfoViewController.h
//  服务器基本信息页面
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCViewController.h"

@class TCServer;
@interface TCServerInfoViewController : TCViewController

- (instancetype) initWithServer:(TCServer*)server;

@end
