//
//  TCServerNet+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerNet+CoreDataProperties.h"

@implementation TCServerNet (CoreDataProperties)

+ (NSFetchRequest<TCServerNet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerNet"];
}

@dynamic output;
@dynamic intput;

@end
