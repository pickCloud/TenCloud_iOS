//
//  TCStaffLabel.h
//  TenCloud
//
//  Created by huangdx on 2017/12/29.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCStaffType) {
    TCStaffTypeStaff           =    0,
    TCStaffTypeAdmin
};

@interface TCStaffLabel : UILabel

@property (nonatomic, assign)   TCStaffType type;

@end
