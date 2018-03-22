//
//  TCServerSystemConfig+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerSystemConfig+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class TCDiskInfo;
@class TCImageInfo;
@interface TCServerSystemConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerSystemConfig *> *)fetchRequest;

@property (nonatomic) int64_t cpu;
@property (nullable, nonatomic, copy) NSString *instance_network_type;
@property (nullable, nonatomic, copy) NSString *max_bandwidth_in;
@property (nullable, nonatomic, copy) NSString *max_bandwidth_out;
@property (nonatomic) int64_t memory;
@property (nullable, nonatomic, copy) NSString *os_name;
@property (nullable, nonatomic, copy) NSString *os_type;
@property (nullable, nonatomic, copy) NSString *security_group_ids;
@property (nullable, nonatomic, retain) NSMutableArray<TCDiskInfo*> *disk_info;
@property (nullable, nonatomic, retain) NSMutableArray<TCImageInfo*> *image_info;

@end

NS_ASSUME_NONNULL_END
