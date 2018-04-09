//
//  TCCloud+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/4/8.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCCloud+CoreDataProperties.h"

@implementation TCCloud (CoreDataProperties)

+ (NSFetchRequest<TCCloud *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCCloud"];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cloudID":@"id"};
}

@dynamic cloudID;
@dynamic name;
@dynamic icon;

@end
