//
//  TCServerDetailViewController.h
//  TenCloud
//
//  Created by huangdx on 2017/12/13.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VTMagic/VTMagic.h>

@interface TCServerDetailViewController : VTMagicController

- (instancetype) initWithID:(NSInteger)serverID name:(NSString*)name;

@end
