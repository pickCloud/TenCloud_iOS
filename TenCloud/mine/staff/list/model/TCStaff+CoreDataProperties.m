//
//  TCStaff+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/4.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCStaff+CoreDataProperties.h"

@implementation TCStaff (CoreDataProperties)

+ (NSFetchRequest<TCStaff *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCStaff"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"staffID":@"id"
             };
}

@dynamic is_admin;
@dynamic uid;
@dynamic update_time;
@dynamic create_time;
@dynamic image_url;
@dynamic mobile;
@dynamic name;
@dynamic staffID;
@dynamic status;

@end
