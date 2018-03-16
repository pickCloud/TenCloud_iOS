//
//  TCServerSystemConfig+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/16.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerSystemConfig+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerSystemConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerSystemConfig *> *)fetchRequest;

@property (nonatomic) int64_t cpu;
@property (nonatomic) int64_t memory;
@property (nullable, nonatomic, copy) NSString *os_name;
@property (nullable, nonatomic, copy) NSString *os_type;
@property (nullable, nonatomic, copy) NSString *instance_network_type;
@property (nullable, nonatomic, copy) NSString *max_bandwidth_out;
@property (nullable, nonatomic, copy) NSString *max_bandwidth_in;
@property (nullable, nonatomic, copy) NSString *system_disk_size;
@property (nullable, nonatomic, copy) NSString *system_disk_type;
@property (nullable, nonatomic, copy) NSString *security_group_ids;
@property (nullable, nonatomic, copy) NSString *system_disk_id;
@property (nullable, nonatomic, copy) NSString *image_id;
@property (nullable, nonatomic, copy) NSString *image_name;
@property (nullable, nonatomic, copy) NSString *image_version;

@end

NS_ASSUME_NONNULL_END
