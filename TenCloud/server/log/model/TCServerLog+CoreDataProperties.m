//
//  TCServerLog+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerLog+CoreDataProperties.h"

@implementation TCServerLog (CoreDataProperties)

+ (NSFetchRequest<TCServerLog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerLog"];
}

@dynamic create_time;
@dynamic operation_status;
@dynamic user;
@dynamic operation;

@end
