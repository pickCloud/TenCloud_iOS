//
//  TCServerConfig+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerConfig+CoreDataProperties.h"

@implementation TCServerConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerConfig *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerConfig"];
}

@dynamic basic_info;
@dynamic business_info;
@dynamic system_info;

@end
