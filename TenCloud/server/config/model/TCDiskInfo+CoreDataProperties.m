//
//  TCDiskInfo+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCDiskInfo+CoreDataProperties.h"

@implementation TCDiskInfo (CoreDataProperties)

+ (NSFetchRequest<TCDiskInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCDiskInfo"];
}

@dynamic system_disk_id;
@dynamic system_disk_type;
@dynamic system_disk_size;

@end
