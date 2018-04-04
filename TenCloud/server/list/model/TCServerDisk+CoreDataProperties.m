//
//  TCServerDisk+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/4/4.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerDisk+CoreDataProperties.h"

@implementation TCServerDisk (CoreDataProperties)

+ (NSFetchRequest<TCServerDisk *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerDisk"];
}

@dynamic created_time;
@dynamic free;
@dynamic percent;
@dynamic total;
@dynamic utilize;

@end
