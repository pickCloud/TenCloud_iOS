//
//  TCServerPerformance+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerPerformance+CoreDataProperties.h"

@implementation TCServerPerformance (CoreDataProperties)

+ (NSFetchRequest<TCServerPerformance *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerPerformance"];
}

+ (NSDictionary *) mj_objectClassInArray
{
    return @{
             @"disk" : @"TCServerDisk",
             @"memory":@"TCServerMemory",
             @"cpu":@"TCServerCPU",
             @"net":@"TCServerNet"
             };
}

@dynamic disk;
@dynamic memory;
@dynamic cpu;
@dynamic net;

@end
