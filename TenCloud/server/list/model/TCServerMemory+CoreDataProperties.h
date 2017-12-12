//
//  TCServerMemory+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerMemory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerMemory (CoreDataProperties)

+ (NSFetchRequest<TCServerMemory *> *)fetchRequest;

@property (nonatomic) int64_t available;
@property (nonatomic) int64_t free;
@property (nullable, nonatomic, retain) NSNumber *percent;
@property (nonatomic) int64_t total;
@property (nonatomic) int64_t created_time;

@end

NS_ASSUME_NONNULL_END
