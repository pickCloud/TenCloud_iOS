//
//  TCAppProfileMirrorCell.h
//  功能:应用详情页 镜像Cell
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCMirror;
@interface TCAppProfileMirrorCell : UITableViewCell

- (void) setMirror:(TCMirror*)mirror showSeperator:(BOOL)isShow;

@end
