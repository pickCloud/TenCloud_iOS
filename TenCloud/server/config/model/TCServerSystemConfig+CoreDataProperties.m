//
//  TCServerSystemConfig+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerSystemConfig+CoreDataProperties.h"

@implementation TCServerSystemConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerSystemConfig *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerSystemConfig"];
}

@dynamic memory;
@dynamic os_type;
@dynamic os_name;
@dynamic cpu;

@end
