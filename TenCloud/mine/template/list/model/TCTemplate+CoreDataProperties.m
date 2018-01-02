//
//  TCTemplate+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTemplate+CoreDataProperties.h"

@implementation TCTemplate (CoreDataProperties)

+ (NSFetchRequest<TCTemplate *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCTemplate"];
}

@dynamic tid;
@dynamic type;
@dynamic cid;
@dynamic access_filehub;
@dynamic name;
@dynamic access_projects;
@dynamic permissions;
@dynamic access_servers;
@dynamic create_time;
@dynamic update_time;

@end
