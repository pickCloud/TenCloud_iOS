//
//  TCServerImageInfoCell.h
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCImageInfo;
@interface TCServerImageInfoCell : UITableViewCell

- (void) setImageInfo:(TCImageInfo*)info withNumber:(NSInteger)number;

@end
