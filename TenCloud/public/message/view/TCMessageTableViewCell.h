//
//  TCMessageTableViewCell.h
//  TenCloud
//
//  Created by huangdx on 2018/1/17.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCMessageTableViewCell;
@class TCMessage;
typedef void (^TCMessageTableViewCellActionBlock)(TCMessageTableViewCell *cell, TCMessage *message);
@interface TCMessageTableViewCell : UITableViewCell

@property (nonatomic, copy) TCMessageTableViewCellActionBlock   actionBlock;

- (void) setMessage:(TCMessage*)message;

@end
