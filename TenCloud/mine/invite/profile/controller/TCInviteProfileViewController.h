//
//  TCInviteProfileViewController.h
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCViewController.h"

@interface TCInviteProfileViewController : TCViewController

- (instancetype) initWithCode:(NSString*)code
                  joinSetting:(NSString*)setting
            shouldSetPassword:(BOOL)setPassword
                  phoneNumber:(NSString*)phoneNumStr;

@end
