//
//  TCPermissionItem+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionItem+CoreDataProperties.h"

@implementation TCPermissionItem (CoreDataProperties)

+ (NSFetchRequest<TCPermissionItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionItem"];
}

@dynamic permID;
@dynamic name;
@dynamic group;

@end
