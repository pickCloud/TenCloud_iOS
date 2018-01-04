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
#import "TCTemplate+CoreDataClass.h"

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

/*
- (void) reset
{
    [_permissionSegArray removeAllObjects];
    NSArray *emptyArray = [[TCEmptyTemplate shared] templateArray];
    NSLog(@"emptyArray:%@",emptyArray);
    [_permissionSegArray addObjectsFromArray:[emptyArray mutableCopy]];
    NSLog(@"_perSegArray:%@",_permissionSegArray);
    

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
 */
- (void) reset
{
    [_permissionSegArray removeAllObjects];
    NSArray *emptyArray = [[TCEmptyTemplate shared] templateArray];
    //NSLog(@"emptyArray:%@",emptyArray);
    [_permissionSegArray addObjectsFromArray:[emptyArray mutableCopy]];
    //NSLog(@"_perSegArray:%@",_permissionSegArray);
    
    
    for (TCPermissionSegment * seg in _permissionSegArray)
    {
        for (TCPermissionSection *sec in seg.data)
        {
            for (TCPermissionChunk *chunk in sec.data)
            {
                chunk.fold = NO;
                chunk.selected = NO;
                chunk.hidden = NO;
                for (TCPermissionItem *item in chunk.data)
                {
                    [item setFatherItem:chunk];
                    item.selected = NO;
                    item.hidden = NO;
                    if ([sec.name isEqualToString:@"文件"])
                    {
                        item.name = item.filename;
                    }
                }
            }
        }
    }
}

- (void) setTemplate:(TCTemplate*)tmpl
{
    NSString *permissionsStr = tmpl.permissions;
    if (permissionsStr && permissionsStr.length > 0)
    {
        NSArray *permissionIDArray = [permissionsStr componentsSeparatedByString:@","];
        if (permissionIDArray && permissionIDArray.count > 0)
        {
            for (NSNumber *pIDNum in permissionIDArray)
            {
                TCPermissionSegment *seg = _permissionSegArray.firstObject;
                for (TCPermissionSection *sec in seg.data)
                {
                    for (TCPermissionChunk * chunk in sec.data)
                    {
                        for (TCPermissionItem * item in chunk.data)
                        {
                            if (item.permID == pIDNum.integerValue)
                            {
                                item.selected = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSString *serverPermissionsStr = tmpl.access_servers;
    if (serverPermissionsStr && serverPermissionsStr.length > 0)
    {
        NSArray *serverPerIDArray = [serverPermissionsStr componentsSeparatedByString:@","];
        if (serverPerIDArray && serverPerIDArray.count > 0)
        {
            for (NSNumber *pIDNum in serverPerIDArray)
            {
                TCPermissionSegment *seg = [_permissionSegArray objectAtIndex:1];
                for (TCPermissionSection *sec in seg.data)
                {
                    for (TCPermissionChunk * chunk in sec.data)
                    {
                        for (TCPermissionItem * item in chunk.data)
                        {
                            if (item.permID == pIDNum.integerValue)
                            {
                                item.selected = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSString *projPermissionsStr = tmpl.access_projects;
    if (projPermissionsStr && projPermissionsStr.length > 0)
    {
        NSArray *projPerIDArray = [projPermissionsStr componentsSeparatedByString:@","];
        if (projPerIDArray && projPerIDArray.count > 0)
        {
            for (NSNumber *pIDNum in projPerIDArray)
            {
                TCPermissionSegment *seg = [_permissionSegArray objectAtIndex:1];
                for (TCPermissionSection *sec in seg.data)
                {
                    for (TCPermissionChunk * chunk in sec.data)
                    {
                        for (TCPermissionItem * item in chunk.data)
                        {
                            if (item.permID == pIDNum.integerValue)
                            {
                                item.selected = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSString *filePermissionsStr = tmpl.access_filehub;
    if (filePermissionsStr && filePermissionsStr.length > 0)
    {
        NSArray *filePerIDArray = [filePermissionsStr componentsSeparatedByString:@","];
        if (filePerIDArray && filePerIDArray.count > 0)
        {
            for (NSNumber *pIDNum in filePerIDArray)
            {
                TCPermissionSegment *seg = [_permissionSegArray objectAtIndex:1];
                for (TCPermissionSection *sec in seg.data)
                {
                    for (TCPermissionChunk * chunk in sec.data)
                    {
                        for (TCPermissionItem * item in chunk.data)
                        {
                            if (item.permID == pIDNum.integerValue)
                            {
                                item.selected = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
    for (TCPermissionSegment * seg in _permissionSegArray)
    {
        for (TCPermissionSection *sec in seg.data)
        {
            for (TCPermissionChunk *chunk in sec.data)
            {
                BOOL tmpSelected = YES;
                for (TCPermissionItem *item in chunk.data)
                {
                    tmpSelected &= item.selected;
                }
                chunk.selected = tmpSelected;
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
