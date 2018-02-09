//
//  TCServerInfoItem.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerInfoItem.h"

@implementation TCServerInfoItem

- (instancetype) initWithKey:(NSString*)key value:(NSString*)value
{
    return [self initWithKey:key value:value type:TCInfoCellTypeNormal];
}

- (instancetype) initWithKey:(NSString*)key value:(NSString*)value type:(TCInfoCellType)type
{
    self = [super init];
    if (self)
    {
        _key = key;
        _value = value;
        _cellType = type;
    }
    return self;
}

- (instancetype) initWithKey:(NSString *)key value:(NSString *)value disclosure:(BOOL)disclosure
{
    self = [super init];
    if (self)
    {
        _key = key;
        _value = value;
        _disclosure = disclosure;
    }
    return self;
}
@end
