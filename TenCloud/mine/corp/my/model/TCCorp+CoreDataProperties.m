//
//  TCCorp+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/17.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCCorp+CoreDataProperties.h"

@implementation TCCorp (CoreDataProperties)

+ (NSFetchRequest<TCCorp *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCCorp"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description",
             @"cid":@"id"
             };
}

@dynamic cid;
@dynamic company_name;
@dynamic contact;
@dynamic create_time;
@dynamic desc;
@dynamic is_admin;
@dynamic mobile;
@dynamic name;
@dynamic status;
@dynamic update_time;
@dynamic image_url;

@end
