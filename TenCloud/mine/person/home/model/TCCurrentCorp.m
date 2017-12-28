//
//  TCCurrentCorp.m
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCurrentCorp.h"
#import "TCCorp+CoreDataClass.h"

@implementation TCCurrentCorp

+ (instancetype) shared
{
    static TCCurrentCorp *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCCurrentCorp alloc] init];
    });
    return instance;
}

- (BOOL) isCurrent:(TCCorp*)corp
{
    if (corp.cid == 0 && _name == nil)
    {
        return YES;
    }
    if (corp.cid == 0 && [_name isEqualToString:corp.company_name])
    {
        return YES;
    }
    if (_cid == corp.cid &&
        [_name isEqualToString:corp.company_name])
    {
        return YES;
    }
    return NO;
}
@end
