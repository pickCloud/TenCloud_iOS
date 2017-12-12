//
//  TCServerMemory+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerMemory+CoreDataProperties.h"

@implementation TCServerMemory (CoreDataProperties)

+ (NSFetchRequest<TCServerMemory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerMemory"];
}

@dynamic available;
@dynamic free;
@dynamic percent;
@dynamic total;
@dynamic created_time;

@end
