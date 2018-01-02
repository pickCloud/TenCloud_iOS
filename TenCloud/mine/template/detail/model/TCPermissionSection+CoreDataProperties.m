//
//  TCPermissionSection+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionSection+CoreDataProperties.h"

@implementation TCPermissionSection (CoreDataProperties)

+ (NSFetchRequest<TCPermissionSection *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionSection"];
}

@dynamic name;
@dynamic data;

@end
