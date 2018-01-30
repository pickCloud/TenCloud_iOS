//
//  TCPerformanceItem+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/30.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPerformanceItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class TCServerDisk;
@class TCServerMemory;
@class TCServerCPU;
@class TCServerNet;
@interface TCPerformanceItem (CoreDataProperties)

+ (NSFetchRequest<TCPerformanceItem *> *)fetchRequest;

@property (nonatomic) int64_t created_time;
@property (nullable, nonatomic, retain) TCServerDisk *disk;
@property (nullable, nonatomic, retain) TCServerMemory *memory;
@property (nullable, nonatomic, retain) TCServerCPU *cpu;
@property (nullable, nonatomic, retain) TCServerNet *net;

@end

NS_ASSUME_NONNULL_END
