//
//  TCServerBusinessInfo+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerBusinessInfo+CoreDataProperties.h"

@implementation TCServerBusinessInfo (CoreDataProperties)

+ (NSFetchRequest<TCServerBusinessInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerBusinessInfo"];
}

@dynamic provider;
@dynamic contract;

@end
