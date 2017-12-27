//
//  TCCellData.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCellData.h"

@implementation TCCellData
- (id) init
{
    self = [super init];
    if (self)
    {
        _hideDetailView = NO;
    }
    return self;
}

- (void) setInitialValue:(id)initialValue
{
    _initialValue = initialValue;
    _value = _initialValue;
}

@end