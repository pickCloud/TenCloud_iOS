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
    self = [super init];
    if (self)
    {
        _key = key;
        _value = value;
    }
    return self;
}
@end
