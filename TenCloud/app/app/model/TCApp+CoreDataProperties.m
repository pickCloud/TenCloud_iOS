//
//  TCApp+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/4/4.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCApp+CoreDataProperties.h"

@implementation TCApp (CoreDataProperties)

+ (NSFetchRequest<TCApp *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCApp"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description",
             @"appID":@"id"
             };
}

@dynamic appID;
@dynamic logo_url;
@dynamic create_time;
@dynamic labels;
@dynamic name;
@dynamic status;
@dynamic update_time;
@dynamic repos_name;
@dynamic lord;
@dynamic repos_https_url;
@dynamic desc;
@dynamic repos_ssh_url;
@dynamic form;
@dynamic image_id;

@end
