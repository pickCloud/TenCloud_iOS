//
//  TCListCorp+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/18.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCListCorp+CoreDataProperties.h"

@implementation TCListCorp (CoreDataProperties)

+ (NSFetchRequest<TCListCorp *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCListCorp"];
}

@dynamic cid;
@dynamic company_name;
@dynamic create_time;
@dynamic is_admin;
@dynamic status;
@dynamic update_time;
@dynamic code;

@end
