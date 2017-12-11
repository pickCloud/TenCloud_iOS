//
//  TCServerLog+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerLog+CoreDataProperties.h"

@implementation TCServerLog (CoreDataProperties)

+ (NSFetchRequest<TCServerLog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerLog"];
}

@dynamic created_time;
@dynamic operation;
@dynamic operation_status;
@dynamic user;

@end
