//
//  TCServerDisk+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerDisk+CoreDataProperties.h"

@implementation TCServerDisk (CoreDataProperties)

+ (NSFetchRequest<TCServerDisk *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerDisk"];
}

@dynamic free;
@dynamic percent;
@dynamic total;
@dynamic created_time;

@end
