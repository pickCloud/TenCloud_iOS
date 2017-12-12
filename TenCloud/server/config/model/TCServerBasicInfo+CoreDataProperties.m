//
//  TCServerBasicInfo+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerBasicInfo+CoreDataProperties.h"

@implementation TCServerBasicInfo (CoreDataProperties)

+ (NSFetchRequest<TCServerBasicInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerBasicInfo"];
}

@dynamic machine_status;
@dynamic created_time;
@dynamic cluster_name;
@dynamic cluster_id;
@dynamic address;
@dynamic public_ip;
@dynamic instance_id;
@dynamic business_status;
@dynamic name;
@dynamic region_id;
@dynamic serverID;

@end
