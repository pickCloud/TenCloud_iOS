//
//  TCTemplateChunk+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTemplateChunk+CoreDataProperties.h"

@implementation TCTemplateChunk (CoreDataProperties)

+ (NSFetchRequest<TCTemplateChunk *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCTemplateChunk"];
}

@dynamic name;
@dynamic data;

@end
