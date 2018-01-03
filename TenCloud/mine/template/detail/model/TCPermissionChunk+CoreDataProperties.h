//
//  TCPermissionChunk+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionChunk+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCPermissionChunk (CoreDataProperties)

+ (NSFetchRequest<TCPermissionChunk *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSArray *data;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
