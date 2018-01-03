//
//  TCPermissionChunk+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionChunk+CoreDataProperties.h"

@implementation TCPermissionChunk (CoreDataProperties)

+ (NSFetchRequest<TCPermissionChunk *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionChunk"];
}

+ (NSDictionary *) mj_objectClassInArray
{
    return @{
             @"data" : @"TCPermissionItem"
             };
}

@dynamic data;
@dynamic name;

@end
