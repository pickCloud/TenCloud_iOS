//
//  TCPermissionNode+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/5.
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
        if (subNode.fold == YES)
        {
            subAmount = 1;
        }else if(subNode.hidden == YES)
        {
            subAmount = 0;
        }else if(subNode.data == nil || subNode.data.count == 0)
        {
            subAmount = 1;
        }
        else
        {
            subAmount = [subNode subNodeAmount] + 1;
        }
        amount += subAmount;
    }
    NSLog(@"subNode:%@ fold:%d Amount:%ld",self.name, self.fold, amount);
    return amount;
}

- (TCPermissionNode*) subNodeAtIndex:(NSInteger)index
{
    NSInteger tmpIndex = 0;
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

@dynamic permID;
@dynamic name;
@dynamic filename;
@dynamic data;
@dynamic depth;
@dynamic fold;
@dynamic selected;
@dynamic hidden;
@dynamic fatherNode;

@end
