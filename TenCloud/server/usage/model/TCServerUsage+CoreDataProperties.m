//
//  TCServerUsage+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/29.
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
@dynamic diskUtilize;
@dynamic diskUsageRate;
@dynamic memUsageRate;
@dynamic name;
@dynamic netDownload;
@dynamic netUpload;
@dynamic netUsageRate;
@dynamic serverID;
@dynamic netOutputMax;
@dynamic netInputMax;

@end
