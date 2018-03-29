//
//  TCSystemLoad+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/29.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCSystemLoad+CoreDataProperties.h"

@implementation TCSystemLoad (CoreDataProperties)

+ (NSFetchRequest<TCSystemLoad *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCSystemLoad"];
}

@dynamic date;
@dynamic fifth_minute_load;
@dynamic five_minute_load;
@dynamic login_users;
@dynamic one_minute_load;
@dynamic run_time;
@dynamic monitor;

@end
