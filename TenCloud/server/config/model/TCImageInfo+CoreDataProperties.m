//
//  TCImageInfo+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCImageInfo+CoreDataProperties.h"

@implementation TCImageInfo (CoreDataProperties)

+ (NSFetchRequest<TCImageInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCImageInfo"];
}

@dynamic image_name;
@dynamic image_id;
@dynamic image_version;

@end
