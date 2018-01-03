//
//  TCPermissionSegment+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionSegment+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCPermissionSegment (CoreDataProperties)

+ (NSFetchRequest<TCPermissionSegment *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSArray *data;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
