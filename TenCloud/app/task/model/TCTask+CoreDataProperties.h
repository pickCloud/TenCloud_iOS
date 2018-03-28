//
//  TCTask+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTask+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCTask (CoreDataProperties)

+ (NSFetchRequest<TCTask *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *status;
@property (nonatomic) double progress;
@property (nonatomic) int64_t startTime;
@property (nonatomic) int64_t endTime;

@end

NS_ASSUME_NONNULL_END
