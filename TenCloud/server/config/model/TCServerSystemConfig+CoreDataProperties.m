//
//  TCServerSystemConfig+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
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

+ (NSDictionary *) mj_objectClassInArray
{
    return @{
             @"disk_info" : @"TCDiskInfo",
             @"image_info" : @"TCImageInfo"
             };
}

@dynamic cpu;
@dynamic instance_network_type;
@dynamic max_bandwidth_in;
@dynamic max_bandwidth_out;
@dynamic memory;
@dynamic os_name;
@dynamic os_type;
@dynamic security_group_ids;
@dynamic disk_info;
@dynamic image_info;

@end
