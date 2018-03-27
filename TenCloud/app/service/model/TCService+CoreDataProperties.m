//
//  TCService+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCService+CoreDataProperties.h"

@implementation TCService (CoreDataProperties)

+ (NSFetchRequest<TCService *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCService"];
}

@dynamic serviceID;
@dynamic name;
@dynamic labels;
@dynamic status;
@dynamic clusterIP;
@dynamic loadBalancing;
@dynamic outerIP;
@dynamic port;
@dynamic createTime;

@end
