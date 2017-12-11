//
//  TCServerNet+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerNet+CoreDataProperties.h"

@implementation TCServerNet (CoreDataProperties)

+ (NSFetchRequest<TCServerNet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerNet"];
}

@dynamic input;
@dynamic output;

@end
