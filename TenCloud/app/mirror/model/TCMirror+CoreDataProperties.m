//
//  TCMirror+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCMirror+CoreDataProperties.h"

@implementation TCMirror (CoreDataProperties)

+ (NSFetchRequest<TCMirror *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCMirror"];
}

@dynamic mirrorID;
@dynamic name;
@dynamic version;
@dynamic updateTime;

@end
