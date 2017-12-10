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

@dynamic mobile;
@dynamic token;
@dynamic name;
@dynamic email;
@dynamic userID;
@dynamic create_time;
@dynamic update_time;
@dynamic gender;
@dynamic birthday;

@end
