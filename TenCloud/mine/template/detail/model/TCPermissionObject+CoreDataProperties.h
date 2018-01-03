//
//  TCPermissionObject+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCPermissionObject (CoreDataProperties)

+ (NSFetchRequest<TCPermissionObject *> *)fetchRequest;

@property (nonatomic) int64_t objID;
@property (nonatomic) int64_t depth;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL fold;
@property (nonatomic) BOOL hidden;

@end

NS_ASSUME_NONNULL_END
