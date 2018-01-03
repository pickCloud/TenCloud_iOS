//
//  TCPermissionItem+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionItem+CoreDataProperties.h"

@implementation TCPermissionItem (CoreDataProperties)

+ (NSFetchRequest<TCPermissionItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionItem"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"permID":@"id"
             };
}

@dynamic fatherItem;
@dynamic group;
@dynamic name;
@dynamic permID;
@dynamic filename;

@end