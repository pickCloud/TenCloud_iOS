//
//  TCServerUsage+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/13.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerUsage+CoreDataProperties.h"

@implementation TCServerUsage (CoreDataProperties)

+ (NSFetchRequest<TCServerUsage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerUsage"];
}

@dynamic cpuUsageRate;
@dynamic diskUsageRate;
@dynamic memoryUsageRate;
@dynamic networkUsage;
@dynamic diskIO;
@dynamic serverID;
@dynamic name;
@dynamic type;

@end
