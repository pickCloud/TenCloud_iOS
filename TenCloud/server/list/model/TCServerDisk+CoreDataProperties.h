//
//  TCServerDisk+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerDisk+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerDisk (CoreDataProperties)

+ (NSFetchRequest<TCServerDisk *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSNumber *free;
@property (nullable, nonatomic, retain) NSNumber *percent;
@property (nullable, nonatomic, retain) NSNumber *total;
@property (nonatomic) int64_t created_time;

@end

NS_ASSUME_NONNULL_END
