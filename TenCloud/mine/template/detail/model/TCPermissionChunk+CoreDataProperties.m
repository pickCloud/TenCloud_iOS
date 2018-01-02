//
//  TCPermissionChunk+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionChunk+CoreDataProperties.h"

@implementation TCPermissionChunk (CoreDataProperties)

+ (NSFetchRequest<TCPermissionChunk *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionChunk"];
}

@dynamic name;
@dynamic data;

@end
