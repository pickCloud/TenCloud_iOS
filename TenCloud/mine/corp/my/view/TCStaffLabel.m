//
//  TCStaffLabel.m
//  TenCloud
//
//  Created by huangdx on 2017/12/29.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCStaffLabel.h"

@implementation TCStaffLabel

- (void) setType:(TCStaffType)type
{
    if (type == TCStaffTypeAdmin)
    {
        self.text = @" 管理员 ";
        self.textColor = THEME_TINT_COLOR;
        self.layer.borderWidth = 0.4;
        self.layer.cornerRadius = 4.0;
        self.layer.borderColor = THEME_TINT_COLOR.CGColor;
    }else
    {
        self.text = @" 员工 ";
        self.textColor = THEME_TEXT_COLOR;
        self.layer.borderWidth = 0.4;
        self.layer.cornerRadius = 4.0;
        self.layer.borderColor = THEME_TEXT_COLOR.CGColor;
    }
}

@end
