//
//  TCTemplateSegment+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTemplateSegment+CoreDataProperties.h"

@implementation TCTemplateSegment (CoreDataProperties)

+ (NSFetchRequest<TCTemplateSegment *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCTemplateSegment"];
}

@dynamic name;
@dynamic data;

@end
