//
//  TCPermissionSegment+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionSegment+CoreDataProperties.h"

@implementation TCPermissionSegment (CoreDataProperties)

+ (NSFetchRequest<TCPermissionSegment *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPermissionSegment"];
}

+ (NSDictionary *) mj_objectClassInArray
{
    return @{
             @"data" : @"TCPermissionSection"
             };
}

@dynamic data;
@dynamic name;

@end
