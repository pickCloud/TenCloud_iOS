//
//  TCPermissionSegment+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionSegment+CoreDataProperties.h"

@implementation TCPermissionSegment (CoreDataProperties)

+ (NSFetchRequest<TCPermissionSegment *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionSegment"];
}

@dynamic name;
@dynamic data;

@end
