//
//  TCServerBusinessContract+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/29.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerBusinessContract+CoreDataProperties.h"

@implementation TCServerBusinessContract (CoreDataProperties)

+ (NSFetchRequest<TCServerBusinessContract *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerBusinessContract"];
}

@dynamic charge_type;
@dynamic create_time;
@dynamic expired_time;
@dynamic instance_charge_type;
@dynamic instance_internet_charge_type;

@end
