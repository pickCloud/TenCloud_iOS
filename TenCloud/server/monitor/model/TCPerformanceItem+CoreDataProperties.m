//
//  TCPerformanceItem+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/30.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPerformanceItem+CoreDataProperties.h"

@implementation TCPerformanceItem (CoreDataProperties)

+ (NSFetchRequest<TCPerformanceItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCPerformanceItem"];
}

@dynamic created_time;
@dynamic disk;
@dynamic memory;
@dynamic cpu;
@dynamic net;

@end
