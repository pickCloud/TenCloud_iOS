//
//  TCServer+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServer+CoreDataProperties.h"

@implementation TCServer (CoreDataProperties)

+ (NSFetchRequest<TCServer *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServer"];
}

@dynamic net_content;
@dynamic machine_status;
@dynamic cpu_content;
@dynamic address;
@dynamic public_ip;
@dynamic instance_name;
@dynamic report_time;
@dynamic provider;
@dynamic disk_content;
@dynamic name;
@dynamic memory_content;
@dynamic serverID;

@end
