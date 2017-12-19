//
//  TCServerDetailViewController.h
//  服务器详情总页面
//
//  Created by huangdx on 2017/12/13.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VTMagic/VTMagic.h>

@class TCServer;
@interface TCServerDetailViewController : VTMagicController

- (instancetype) initWithServer:(TCServer*)server;

@end
