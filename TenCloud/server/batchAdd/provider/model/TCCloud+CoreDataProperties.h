//
//  TCCloud+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/4/8.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCCloud+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCCloud (CoreDataProperties)

+ (NSFetchRequest<TCCloud *> *)fetchRequest;

@property (nonatomic) int64_t cloudID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *icon;

@end

NS_ASSUME_NONNULL_END
