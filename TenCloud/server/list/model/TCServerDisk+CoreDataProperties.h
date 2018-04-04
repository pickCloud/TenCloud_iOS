//
//  TCServerDisk+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/4/4.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerDisk+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerDisk (CoreDataProperties)

+ (NSFetchRequest<TCServerDisk *> *)fetchRequest;

@property (nonatomic) int64_t created_time;
@property (nullable, nonatomic, retain) NSNumber *free;
@property (nullable, nonatomic, retain) NSNumber *percent;
@property (nullable, nonatomic, retain) NSNumber *total;
@property (nonatomic) int64_t utilize;

@end

NS_ASSUME_NONNULL_END
