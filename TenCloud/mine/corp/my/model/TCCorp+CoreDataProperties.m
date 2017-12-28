//
//  TCCorp+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCCorp+CoreDataProperties.h"

@implementation TCCorp (CoreDataProperties)

+ (NSFetchRequest<TCCorp *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCCorp"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description"};
}

@dynamic cid;
@dynamic company_name;
@dynamic contact;
@dynamic create_time;
@dynamic desc;
@dynamic is_admin;
@dynamic mobile;
@dynamic status;
@dynamic update_time;
@dynamic name;

@end
