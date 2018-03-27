//
//  TCDeploy+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCDeploy+CoreDataProperties.h"

@implementation TCDeploy (CoreDataProperties)

+ (NSFetchRequest<TCDeploy *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCDeploy"];
}

@dynamic deployID;
@dynamic name;
@dynamic status;
@dynamic runTime;
@dynamic presetPod;
@dynamic currentPod;
@dynamic updatedPod;
@dynamic availablePod;
@dynamic createTime;

@end
