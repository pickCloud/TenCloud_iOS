//
//  TCServerUsage+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/25.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerUsage+CoreDataProperties.h"

@implementation TCServerUsage (CoreDataProperties)

+ (NSFetchRequest<TCServerUsage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerUsage"];
}

@dynamic colorType;
@dynamic cpuUsageRate;
@dynamic diskIO;
@dynamic diskUsageRate;
@dynamic memUsageRate;
@dynamic name;
@dynamic networkUsage;
@dynamic serverID;
@dynamic netDownload;
@dynamic netUpload;

@end
