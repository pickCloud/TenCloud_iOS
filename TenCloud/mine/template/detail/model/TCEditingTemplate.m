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
                //chunk.hidden = NO;
                for (TCPermissionItem *item in chunk.data)
                {
                    //item.hidden = NO;
                    //item.fatherItem = chunk;
                    [item setFatherItem:chunk];
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

- (NSArray *)serverPermissionArray
{
    NSMutableArray *perArray = [NSMutableArray new];
    if (_permissionSegArray.count > 1)
    {
        TCPermissionSegment *dataSeg = [_permissionSegArray objectAtIndex:1];
        
        
        
        /*
        for (TCPermissionSection *sec in dataSeg.data)
        {
            for (TCPermissionChunk * chunk in sec.data)
            {
                for (TCPermissionItem * item in chunk.data)
                {
                    if (item.selected)
                    {
                        
                    }
                }
            }
        }
         */
    }
    return perArray;
}

- (NSArray *)projectPermissionArray
{
    NSMutableArray *perArray = [NSMutableArray new];
    
    return perArray;
}

- (NSArray *)filePermissionArray
{
    NSMutableArray *perArray = [NSMutableArray new];
    
    return perArray;
}
@end
