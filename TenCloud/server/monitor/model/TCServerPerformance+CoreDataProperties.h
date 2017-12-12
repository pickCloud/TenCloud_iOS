//
//  TCServerPerformance+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerPerformance+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerPerformance (CoreDataProperties)

+ (NSFetchRequest<TCServerPerformance *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSArray *disk;
@property (nullable, nonatomic, retain) NSArray *memory;
@property (nullable, nonatomic, retain) NSArray *cpu;
@property (nullable, nonatomic, retain) NSArray *net;

@end

NS_ASSUME_NONNULL_END
