//
//  TCServerBasicInfo+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerBasicInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerBasicInfo (CoreDataProperties)

+ (NSFetchRequest<TCServerBasicInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *machine_status;
@property (nullable, nonatomic, copy) NSString *created_time;
@property (nullable, nonatomic, copy) NSString *cluster_name;
@property (nonatomic) int64_t cluster_id;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *public_ip;
@property (nullable, nonatomic, copy) NSString *instance_id;
@property (nonatomic) int64_t business_status;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *region_id;
@property (nonatomic) int64_t serverID;

@end

NS_ASSUME_NONNULL_END
