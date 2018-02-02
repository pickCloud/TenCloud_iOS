//
//  TCServerSummary+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/2/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerSummary+CoreDataProperties.h"

@implementation TCServerSummary (CoreDataProperties)

+ (NSFetchRequest<TCServerSummary *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCServerSummary"];
}

@dynamic server_num;
@dynamic warn_num;
@dynamic payment_num;

@end
