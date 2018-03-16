//
//  TCServerThreshold+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/16.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerThreshold+CoreDataProperties.h"

@implementation TCServerThreshold (CoreDataProperties)

+ (NSFetchRequest<TCServerThreshold *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerThreshold"];
}

@dynamic block_threshold;
@dynamic cpu_threshold;
@dynamic disk_threshold;
@dynamic memory_threshold;
@dynamic net_threshold;

@end
