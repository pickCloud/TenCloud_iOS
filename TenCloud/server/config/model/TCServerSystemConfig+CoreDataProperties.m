//
//  TCServerSystemConfig+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/16.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerSystemConfig+CoreDataProperties.h"

@implementation TCServerSystemConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerSystemConfig *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerSystemConfig"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"max_bandwidth_out":@"internet_max_bandwidth_out",
             @"max_bandwidth_in":@"internet_max_bandwidth_in"
             };
}

@dynamic cpu;
@dynamic memory;
@dynamic os_name;
@dynamic os_type;
@dynamic instance_network_type;
@dynamic max_bandwidth_out;
@dynamic max_bandwidth_in;
@dynamic system_disk_size;
@dynamic system_disk_type;
@dynamic security_group_ids;
@dynamic system_disk_id;
@dynamic image_id;
@dynamic image_name;
@dynamic image_version;

@end
