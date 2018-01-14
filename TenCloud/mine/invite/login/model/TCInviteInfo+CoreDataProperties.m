//
//  TCInviteInfo+CoreDataProperties.m
//  TenCloud
//
//  Created by huangdx on 2018/1/14.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCInviteInfo+CoreDataProperties.h"

@implementation TCInviteInfo (CoreDataProperties)

+ (NSFetchRequest<TCInviteInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TCInviteInfo"];
}

@dynamic cid;
@dynamic company_name;
@dynamic contact;
@dynamic setting;

@end
