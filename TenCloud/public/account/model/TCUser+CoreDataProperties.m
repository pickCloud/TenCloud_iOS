//
//  TCUser+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCUser+CoreDataProperties.h"

@implementation TCUser (CoreDataProperties)

+ (NSFetchRequest<TCUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCUser"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"userID":@"id"
             };
}

@dynamic birthday;
@dynamic create_time;
@dynamic email;
@dynamic gender;
@dynamic mobile;
@dynamic name;
@dynamic token;
@dynamic update_time;
@dynamic userID;
@dynamic image_url;

@end
