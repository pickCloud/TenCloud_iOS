//
//  TCAppRepo+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/4/10.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCAppRepo+CoreDataProperties.h"

@implementation TCAppRepo (CoreDataProperties)

+ (NSFetchRequest<TCAppRepo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCAppRepo"];
}

@dynamic repos_name;
@dynamic repos_url;
@dynamic http_url;

@end
