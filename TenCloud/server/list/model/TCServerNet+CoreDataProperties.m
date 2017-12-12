//
//  TCServerNet+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerNet+CoreDataProperties.h"

@implementation TCServerNet (CoreDataProperties)

+ (NSFetchRequest<TCServerNet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerNet"];
}

@dynamic input;
@dynamic output;
@dynamic created_time;

@end
