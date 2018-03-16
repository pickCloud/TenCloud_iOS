//
//  TCServerThreshold+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/16.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerThreshold+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerThreshold (CoreDataProperties)

+ (NSFetchRequest<TCServerThreshold *> *)fetchRequest;

@property (nonatomic) double block_threshold;
@property (nonatomic) double cpu_threshold;
@property (nonatomic) double disk_threshold;
@property (nonatomic) double memory_threshold;
@property (nonatomic) double net_threshold;

@end

NS_ASSUME_NONNULL_END
