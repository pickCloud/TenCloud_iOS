//
//  TCServerUsage+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerUsage+CoreDataProperties.h"

@implementation TCServerUsage (CoreDataProperties)

+ (NSFetchRequest<TCServerUsage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerUsage"];
}

@dynamic cpuUsageRate;
@dynamic diskIO;
@dynamic diskUsageRate;
@dynamic memUsageRate;
@dynamic name;
@dynamic networkUsage;
@dynamic serverID;
@dynamic colorType;

@end
