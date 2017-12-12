//
//  TCServerSystemConfig+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerSystemConfig+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerSystemConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerSystemConfig *> *)fetchRequest;

@property (nonatomic) int64_t memory;
@property (nullable, nonatomic, copy) NSString *os_type;
@property (nullable, nonatomic, copy) NSString *os_name;
@property (nonatomic) int64_t cpu;

@end

NS_ASSUME_NONNULL_END
