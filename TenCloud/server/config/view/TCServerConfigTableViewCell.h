//
//  TCServerConfigTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCServerConfigTableViewCell : UITableViewCell

- (void) setKey:(NSString*)key value:(NSString*)value;
- (void) setKey:(NSString*)key value:(NSString*)value disclosure:(BOOL)disclosure;

@end
