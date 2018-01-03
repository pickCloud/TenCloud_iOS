//
//  TCPermissionItem+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class TCPermissionChunk;
@interface TCPermissionItem (CoreDataProperties)

+ (NSFetchRequest<TCPermissionItem *> *)fetchRequest;

@property (nullable, nonatomic, retain) TCPermissionChunk *fatherItem;
@property (nonatomic) int64_t group;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t permID;
@property (nullable, nonatomic, copy) NSString *filename;

@end

NS_ASSUME_NONNULL_END
