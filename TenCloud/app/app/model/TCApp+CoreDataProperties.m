//
//  TCApp+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCApp+CoreDataProperties.h"

@implementation TCApp (CoreDataProperties)

+ (NSFetchRequest<TCApp *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCApp"];
}

@dynamic appID;
@dynamic name;
@dynamic labels;
@dynamic source;
@dynamic createTime;
@dynamic updateTime;
@dynamic status;
@dynamic avatar;

@end
