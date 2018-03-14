//
//  TCServerUsage+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/13.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerUsage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TCServerUsageType){
    TCServerUsageIdle   =   0,  //闲置
    TCServerUsageSafe,          //安全,所有指标在临界值下
    TCServerUsageWarning,       //警告,一个指标超过临界值
    TCServerUsageAlert,         //严重警告,两个以上指标超过临界值
    TCServerUsageCrit           //危险,有指标超过资源容量上限
};

@interface TCServerUsage (CoreDataProperties)

+ (NSFetchRequest<TCServerUsage *> *)fetchRequest;

@property (nonatomic) double cpuUsageRate;
@property (nonatomic) double diskUsageRate;
@property (nonatomic) double memoryUsageRate;
@property (nullable, nonatomic, copy) NSString *networkUsage;
@property (nullable, nonatomic, copy) NSString *diskIO;
@property (nonatomic) int64_t serverID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) TCServerUsageType type;

@end

NS_ASSUME_NONNULL_END
