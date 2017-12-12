//
//  TCServerSystemInfo+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerSystemInfo+CoreDataProperties.h"

@implementation TCServerSystemInfo (CoreDataProperties)

+ (NSFetchRequest<TCServerSystemInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerSystemInfo"];
}

@dynamic config;

@end
