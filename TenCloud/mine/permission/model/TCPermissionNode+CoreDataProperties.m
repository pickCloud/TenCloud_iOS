//
//  TCPermissionNode+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/2/7.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionNode+CoreDataProperties.h"

@implementation TCPermissionNode (CoreDataProperties)

+ (NSFetchRequest<TCPermissionNode *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionNode"];
}

+ (NSDictionary *) mj_objectClassInArray
{
    return @{
             @"data" : @"TCPermissionNode"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"permID":@"id"
             };
}

- (NSInteger) subNodeAmount
{
    NSInteger amount = 0;
    for (TCPermissionNode *subNode in self.data)
    {
        NSInteger subAmount = 0;
        BOOL haveSubNode = subNode.data && (subNode.data.count > 0);
        if (subNode.hidden)
        {
            subAmount = 0;
        }else if(!haveSubNode)
        {
            subAmount = 1;
        }else if(subNode.fold && haveSubNode)
        {
            subAmount = 1;
        }else
        {
            subAmount = [subNode subNodeAmount] + 1;
        }
        amount += subAmount;
    }
    return amount;
}

- (TCPermissionNode*) subNodeAtIndex:(NSInteger)index
{
    if (index == 0)
    {
        return self;
    }
    NSInteger tmpIndex = 1;
    for (TCPermissionNode *sub1 in self.data)
    {
        if (sub1.hidden)
        {
            continue;
        }
        if (tmpIndex == index)
        {
            return sub1;
        }
        tmpIndex += 1;
        for (TCPermissionNode *sub2 in sub1.data)
        {
            if (sub2.hidden)
            {
                continue;
            }
            if (tmpIndex == index)
            {
                return sub2;
            }
            tmpIndex += 1;
            for (TCPermissionNode *sub3 in sub2.data)
            {
                if (sub3.hidden)
                {
                    continue;
                }
                if (tmpIndex == index)
                {
                    return sub3;
                }
                tmpIndex += 1;
                for (TCPermissionNode *sub4 in sub3.data)
                {
                    if (sub4.hidden)
                    {
                        continue;
                    }
                    if (tmpIndex == index)
                    {
                        return sub4;
                    }
                    tmpIndex += 1;
                }
                
            }
            
        }
        
    }
    return nil;
}

- (void) updateFatherNodeAfterSubNodeChanged
{
    if (self.fatherNode)
    {
        TCPermissionNode *fatherNode = self.fatherNode;
        BOOL newValue = YES;
        for (TCPermissionNode *subNode in fatherNode.data)
        {
            newValue &= subNode.selected;
        }
        fatherNode.selected = newValue;
        [self.fatherNode updateFatherNodeAfterSubNodeChanged];
    }
}

- (void) updateSubNodesAfterFatherNodeChanged
{
    if (self.data.count > 0)
    {
        for (TCPermissionNode *subNode in self.data)
        {
            subNode.selected = self.selected;
            [subNode updateSubNodesAfterFatherNodeChanged];
        }
    }
}

- (NSArray*)selectedSubNodeIDArray
{
    NSMutableArray *nodes = [NSMutableArray new];
    for (TCPermissionNode *node in self.data)
    {
        if (node.selected)
        {
            if (node.permID > 0)
            {
                [nodes addObject:@(node.permID)];
            }
        }
        NSArray *subArray = [node selectedSubNodeIDArray];
        if (subArray && subArray.count > 0)
        {
            [nodes addObjectsFromArray:subArray];
        }
    }
    return nodes;
}

- (NSArray*)selectedServerSubNodeIDArray
{
    NSMutableArray *nodes = [NSMutableArray new];
    for (TCPermissionNode *node in self.data)
    {
        if (node.selected)
        {
            if (node.sid > 0)
            {
                [nodes addObject:@(node.sid)];
            }
        }
        NSArray *subArray = [node selectedServerSubNodeIDArray];
        if (subArray && subArray.count > 0)
        {
            [nodes addObjectsFromArray:subArray];
        }
    }
    return nodes;
}

- (void) print
{
    NSMutableString *blankStr = [NSMutableString new];
    for (int i = 0; i < self.depth; i++)
    {
        [blankStr appendString:@"  "];
    }
    NSLog(@"%@%@ %p",blankStr,self.name,self);
    for (TCPermissionNode *node in self.data)
    {
        [node print];
    }
}

@dynamic data;
@dynamic depth;
@dynamic fatherNode;
@dynamic filename;
@dynamic fold;
@dynamic hidden;
@dynamic name;
@dynamic permID;
@dynamic provider;
@dynamic public_ip;
@dynamic region_name;
@dynamic selected;
@dynamic sid;
@dynamic status;
@dynamic type;
@dynamic mime;

@end
