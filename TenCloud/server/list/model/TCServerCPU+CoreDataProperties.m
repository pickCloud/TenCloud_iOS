//
//  TCServerCPU+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerCPU+CoreDataProperties.h"

@implementation TCServerCPU (CoreDataProperties)

+ (NSFetchRequest<TCServerCPU *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerCPU"];
}

@dynamic percent;
@dynamic created_time;

@end
