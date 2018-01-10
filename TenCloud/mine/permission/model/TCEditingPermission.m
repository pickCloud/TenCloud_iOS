//
//  TCEditingPermission.m
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCEditingPermission.h"
#import "TCEmptyPermission.h"
#import "TCPermissionNode+CoreDataClass.h"
#import "TCTemplate+CoreDataClass.h"

@implementation TCEditingPermission

+ (instancetype) shared
{
    static TCEditingPermission *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCEditingPermission alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _permissionArray = [NSMutableArray new];
    }
    return self;
}

- (void) reset
{
    [_permissionArray removeAllObjects];
    NSArray *emptyArray = [[TCEmptyPermission shared] permissionArray];
    [_permissionArray addObjectsFromArray:[emptyArray mutableCopy]];
    
    for (TCPermissionNode * subNode in _permissionArray)
    {
        [self resetPermissionNode:subNode];
    }
}

- (void) resetPermissionNode:(TCPermissionNode *)node
{
    for (TCPermissionNode *subNode in node.data)
    {
        subNode.fold = NO;
        subNode.selected = NO;
        subNode.hidden = NO;
        subNode.depth = node.depth + 1;
        subNode.fatherNode = node;
        [self resetPermissionNode:subNode];
    }
}

- (void) selectNodeIfAllSubNodesSelected:(TCPermissionNode *)node
{
    BOOL allSelected = YES;
    for (TCPermissionNode * subNode in node.data)
    {
        if (subNode.data.count > 0)
        {
            [self selectNodeIfAllSubNodesSelected:subNode];
        }
        allSelected &= subNode.selected;
    }
    node.selected = allSelected;
}

- (void) setPermissionNodeSelected:(TCPermissionNode *)node withID:(NSInteger)idInteger
{
    for (TCPermissionNode *subNode in node.data)
    {
        if (subNode.permID == idInteger)
        {
            subNode.selected = YES;
            break;
        }
        if (subNode.data.count > 0)
        {
            [self setPermissionNodeSelected:subNode withID:idInteger];
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
                TCPermissionNode *funNode = _permissionArray.firstObject;
                [self setPermissionNodeSelected:funNode withID:pIDNum.integerValue];
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
                TCPermissionNode *dataNode = [_permissionArray objectAtIndex:1];
                if (dataNode.data.count > 2)
                {
                    TCPermissionNode *serverNode = [dataNode.data objectAtIndex:2];
                    [self setPermissionNodeSelected:serverNode withID:pIDNum.integerValue];
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
                TCPermissionNode *dataNode = [_permissionArray objectAtIndex:1];
                if (dataNode.data.count > 2)
                {
                    TCPermissionNode *projectNode = [dataNode.data objectAtIndex:1];
                    [self setPermissionNodeSelected:projectNode withID:pIDNum.integerValue];
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
                TCPermissionNode *dataNode = [_permissionArray objectAtIndex:1];
                if (dataNode.data.count > 1) 
                {
                    TCPermissionNode *fileNode = [dataNode.data objectAtIndex:0];
                    [self setPermissionNodeSelected:fileNode withID:pIDNum.integerValue];
                }
            }
        }
    }
    
    
    for (TCPermissionNode *subNode in _permissionArray)
    {
        [self selectNodeIfAllSubNodesSelected:subNode];
    }
}

- (void) removeNodeIfAllSubNodesUnselected:(TCPermissionNode *)node
{
    /*
    for (TCPermissionNode *subNode in node.data)
    {
        if (subNode.data.count > 0)
        {
            [self removeNodeIfAllSubNodesUnselected:subNode];
        }else
        {
            if (subNode.depth > 1)
            {
                if (!subNode.selected)
                {
                    [node.data removeObject:subNode];
                }
            }
        }
    }
     */
    int i = (int)node.data.count - 1;
    for (; i >= 0; i--)
    {
        TCPermissionNode *subNode = [node.data objectAtIndex:i];
        if (subNode.data.count > 0)
        {
            [self removeNodeIfAllSubNodesUnselected:subNode];
        }else
        {
            //if (subNode.depth > 1)
            {
                if (!subNode.selected)
                {
                    [node.data removeObject:subNode];
                }
            }
        }
    }
    if (node.data.count == 0)
    {
        [node.fatherNode.data removeObject:node];
    }else
    {
        node.selected = YES;
    }
}


/*
- (void) removeNodeIfAllSubNodesUnselected:(TCPermissionNode *)node
{
    NSLog(@"node %@ select:%d depth:%lld",node.name,node.selected,node.depth);
    BOOL nodeSelected = NO;
    for (TCPermissionNode * subNode in node.data)
    {
        BOOL subNodeSelect = subNode.selected;
        if (subNode.data.count > 0)
        {
            [self removeNodeIfAllSubNodesUnselected:subNode];
        }else
        {
            [self removeNodeIfAllSubNodesUnselected:subNode];
        }
        nodeSelected = nodeSelected || subNodeSelect;
    }
    if (node.depth > 1)
    {
        if (node.data == nil || node.data.count == 0)
        {
            if (!node.selected)
            {
                if (node.fatherNode && node.fatherNode.data.count > 0)
                {
                    [node.fatherNode.data removeObject:node];
                }
                NSLog(@"remove node %@",node.name);
            }
        }else
        {
            if (!nodeSelected)
            {
                if (node.fatherNode && node.fatherNode.data.count > 0)
                {
                    [node.fatherNode.data removeObject:node];
                }
                NSLog(@"remove node %@",node.name);
            }
        }
    }

    //node.selected = allSelected;
}
 */

- (void) readyForPreview
{
    for (TCPermissionNode *subNode in _permissionArray)
    {
        [self removeNodeIfAllSubNodesUnselected:subNode];
    }
}

- (NSInteger) funcPermissionAmount
{
    NSInteger amount = 0;
    TCPermissionNode *funcNode = _permissionArray.firstObject;
    amount = [funcNode selectedSubNodeIDArray].count;
    return amount;
}

- (NSInteger) dataPermissionAmount
{
    NSInteger amount = 0;
    TCPermissionNode *dataNode = [_permissionArray objectAtIndex:1];
    amount = [dataNode selectedSubNodeIDArray].count;
    return amount;
}

- (NSArray *)permissionIDArray
{
    TCPermissionNode *permNode = _permissionArray.firstObject;
    NSArray *resArray = [permNode selectedSubNodeIDArray];
    return resArray;
}

- (NSString *)permissionIDString
{
    NSArray *array = [self permissionIDArray];
    return [array componentsJoinedByString:@","];
}

- (NSString *)serverPermissionIDString
{
    NSArray *array = [self serverPermissionIDArray];
    return [array componentsJoinedByString:@","];
}

- (NSString *)projectPermissionIDString
{
    NSArray *array = [self projectPermissionIDArray];
    return [array componentsJoinedByString:@","];
}

- (NSString *)filePermissionIDString
{
    NSArray *array = [self filePermissionIDArray];
    return [array componentsJoinedByString:@","];
}

- (NSArray *)serverPermissionIDArray
{
    if (_permissionArray.count > 1)
    {
        TCPermissionNode *dataNode = [_permissionArray objectAtIndex:1];
        if (dataNode.data.count > 2)
        {
            TCPermissionNode *serverNode = [dataNode.data objectAtIndex:2];
            return [serverNode selectedSubNodeIDArray];
        }
    }
    return [NSMutableArray new];
}

- (NSArray *)projectPermissionIDArray
{
    if (_permissionArray.count > 1)
    {
        TCPermissionNode *dataNode = [_permissionArray objectAtIndex:1];
        if (dataNode.data.count > 2)
        {
            TCPermissionNode *projectNode = [dataNode.data objectAtIndex:1];
            return [projectNode selectedSubNodeIDArray];
        }
    }
    return [NSMutableArray new];
}

- (NSArray *)filePermissionIDArray
{
    if (_permissionArray.count > 1)
    {
        TCPermissionNode *dataNode = [_permissionArray objectAtIndex:1];
        if (dataNode.data.count > 2)
        {
            TCPermissionNode *fileNode = [dataNode.data objectAtIndex:0];
            return [fileNode selectedSubNodeIDArray];
        }
    }
    return [NSMutableArray new];
}
@end