//
//  TCMessageTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2018/1/17.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCMessage;
@interface TCMessageTableViewCell : UITableViewCell

- (void) setMessage:(TCMessage*)message;

@end
