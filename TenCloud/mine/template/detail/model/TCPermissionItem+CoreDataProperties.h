//
//  TCPermissionItem+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCPermissionItem (CoreDataProperties)

+ (NSFetchRequest<TCPermissionItem *> *)fetchRequest;

@property (nonatomic) int64_t permID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t group;

@end

NS_ASSUME_NONNULL_END
