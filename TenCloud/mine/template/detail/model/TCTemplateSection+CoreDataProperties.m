//
//  TCTemplateSection+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTemplateSection+CoreDataProperties.h"

@implementation TCTemplateSection (CoreDataProperties)

+ (NSFetchRequest<TCTemplateSection *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCTemplateSection"];
}

@dynamic name;
@dynamic data;

@end
