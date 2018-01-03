//
//  TCPermissionObject+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionObject+CoreDataProperties.h"

@implementation TCPermissionObject (CoreDataProperties)

+ (NSFetchRequest<TCPermissionObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionObject"];
}

@dynamic objID;
@dynamic depth;
@dynamic selected;
@dynamic fold;
@dynamic hidden;

@end
