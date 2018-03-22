//
//  TCServerUsage+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerUsage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TCServerUsageType){
    TCServerUsageCrit   =   1,  //危险,有指标超过资源容量上限
    TCServerUsageAlert,         //严重警告,两个以上指标超过临界值
    TCServerUsageWarning,       //警告,一个指标超过临界值
    TCServerUsageSafe,          //安全,所有指标在临界值下
    TCServerUsageIdle           //闲置
};

@interface TCServerUsage (CoreDataProperties)

+ (NSFetchRequest<TCServerUsage *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSNumber *cpuUsageRate;
@property (nullable, nonatomic, copy) NSString *diskIO;
@property (nullable, nonatomic, retain) NSNumber *diskUsageRate;
@property (nullable, nonatomic, retain) NSNumber *memUsageRate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *networkUsage;
@property (nonatomic) int64_t serverID;
@property (nonatomic) int64_t colorType;

@end

NS_ASSUME_NONNULL_END
