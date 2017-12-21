//
//  TCClusterProvider+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCClusterProvider+CoreDataProperties.h"

@implementation TCClusterProvider (CoreDataProperties)

+ (NSFetchRequest<TCClusterProvider *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCClusterProvider"];
}

@dynamic provider;
@dynamic regions;

@end
