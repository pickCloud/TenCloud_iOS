//
//  TCListCorp+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCListCorp+CoreDataProperties.h"

@implementation TCListCorp (CoreDataProperties)

+ (NSFetchRequest<TCListCorp *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCListCorp"];
}

@dynamic cid;
@dynamic company_name;
@dynamic status;
@dynamic create_time;
@dynamic update_time;
@dynamic is_admin;

@end
