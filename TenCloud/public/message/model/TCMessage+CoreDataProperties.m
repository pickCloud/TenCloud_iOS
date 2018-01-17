//
//  TCMessage+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/16.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCMessage+CoreDataProperties.h"

@implementation TCMessage (CoreDataProperties)

+ (NSFetchRequest<TCMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCMessage"];
}

@dynamic owner;
@dynamic mode;
@dynamic update_time;
@dynamic create_time;
@dynamic tip;
@dynamic messageID;
@dynamic sub_mode;
@dynamic content;
@dynamic status;

@end
