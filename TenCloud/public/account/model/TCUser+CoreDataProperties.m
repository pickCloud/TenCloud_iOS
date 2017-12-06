//
//  TCUser+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCUser+CoreDataProperties.h"

@implementation TCUser (CoreDataProperties)

+ (NSFetchRequest<TCUser *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCUser"];
}

@dynamic token;
@dynamic mobile;

@end
