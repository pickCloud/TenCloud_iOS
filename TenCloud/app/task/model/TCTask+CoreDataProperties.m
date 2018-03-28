//
//  TCTask+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTask+CoreDataProperties.h"

@implementation TCTask (CoreDataProperties)

+ (NSFetchRequest<TCTask *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCTask"];
}

@dynamic name;
@dynamic status;
@dynamic progress;
@dynamic startTime;
@dynamic endTime;

@end
