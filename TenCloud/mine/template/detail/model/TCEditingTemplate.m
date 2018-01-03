//
//  TCEditingTemplate.m
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCEditingTemplate.h"
#import "TCEmptyTemplate.h"
#import "TCPermissionSegment+CoreDataClass.h"
#import "TCPermissionSection+CoreDataClass.h"
#import "TCPermissionChunk+CoreDataClass.h"
#import "TCPermissionItem+CoreDataClass.h"

@implementation TCEditingTemplate

+ (instancetype) shared
{
    static TCEditingTemplate *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCEditingTemplate alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _permissionSegArray = [NSMutableArray new];
    }
    return self;
}

- (void) reset
{
    [_permissionSegArray removeAllObjects];
    NSArray *emptyArray = [[TCEmptyTemplate shared] templateArray];
    [_permissionSegArray addObjectsFromArray:[emptyArray mutableCopy]];
    

    for (TCPermissionSegment * seg in _permissionSegArray)
    {
        for (TCPermissionSection *sec in seg.data)
        {
            for (TCPermissionChunk *chunk in sec.data)
            {
                for (TCPermissionItem *item in chunk.data)
                {
                    [item setFatherItem:chunk];
                    if ([sec.name isEqualToString:@"文件"])
                    {
                        item.name = item.filename;
                    }
                }
            }
        }
    }
}

- (NSInteger) funcPermissionAmount
{
    NSInteger amount = 0;
    if (_permissionSegArray.count > 0)
    {
        TCPermissionSegment *seg = _permissionSegArray.firstObject;
        for (TCPermissionSection *sec in seg.data)
        {
            for (TCPermissionChunk * chunk in sec.data)
            {
                for (TCPermissionItem * item in chunk.data)
                {
                    if (item.selected)
                    {
                        amount ++;
                    }
                }
            }
        }
    }
    return amount;
}

- (NSInteger) dataPermissionAmount
{
    NSInteger amount = 0;
    if (_permissionSegArray.count > 1)
    {
        TCPermissionSegment *seg = [_permissionSegArray objectAtIndex:1];
        for (TCPermissionSection *sec in seg.data)
        {
            for (TCPermissionChunk * chunk in sec.data)
            {
                for (TCPermissionItem * item in chunk.data)
                {
                    if (item.selected)
                    {
                        amount ++;
                    }
                }
            }
        }
    }
    return amount;
}

- (NSArray *)permissionIDArray
{
    NSMutableArray *perArray = [NSMutableArray new];
    if (_permissionSegArray.count > 0)
    {
        TCPermissionSegment *seg = _permissionSegArray.firstObject;
        for (TCPermissionSection *sec in seg.data)
        {
            for (TCPermissionChunk * chunk in sec.data)
            {
                for (TCPermissionItem * item in chunk.data)
                {
                    if (item.selected)
                    {
                        [perArray addObject:[NSNumber numberWithInteger:item.permID]];
                    }
                }
            }
        }
    }
    return perArray;
}

- (NSArray *)serverPermissionIDArray
{
    NSMutableArray *perArray = [NSMutableArray new];
    if (_permissionSegArray.count > 1)
    {
        TCPermissionSegment *dataSeg = [_permissionSegArray objectAtIndex:1];
        if (dataSeg.data.count > 2)
        {
            TCPermissionSection *sec = [dataSeg.data objectAtIndex:2];
            for (TCPermissionChunk * chunk in sec.data)
            {
                for (TCPermissionItem * item in chunk.data)
                {
                    if (item.selected)
                    {
                        [perArray addObject:[NSNumber numberWithInteger:item.permID]];
                    }
                }
            }
        }
    }
    return perArray;
}

- (NSArray *)projectPermissionIDArray
{
    NSMutableArray *perArray = [NSMutableArray new];
    if (_permissionSegArray.count > 1)
    {
        TCPermissionSegment *dataSeg = [_permissionSegArray objectAtIndex:1];
        if (dataSeg.data.count > 1)
        {
            TCPermissionSection *sec = [dataSeg.data objectAtIndex:1];
            for (TCPermissionChunk * chunk in sec.data)
            {
                for (TCPermissionItem * item in chunk.data)
                {
                    if (item.selected)
                    {
                        [perArray addObject:[NSNumber numberWithInteger:item.permID]];
                    }
                }
            }
        }
    }
    return perArray;
}

- (NSArray *)filePermissionIDArray
{
    NSMutableArray *perArray = [NSMutableArray new];
    if (_permissionSegArray.count > 1)
    {
        TCPermissionSegment *dataSeg = [_permissionSegArray objectAtIndex:1];
        if (dataSeg.data.count > 1)
        {
            TCPermissionSection *sec = [dataSeg.data objectAtIndex:0];
            for (TCPermissionChunk * chunk in sec.data)
            {
                for (TCPermissionItem * item in chunk.data)
                {
                    if (item.selected)
                    {
                        [perArray addObject:[NSNumber numberWithInteger:item.permID]];
                    }
                }
            }
        }
    }
    return perArray;
}
@end
