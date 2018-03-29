//
//  TCServerUsage+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/29.
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

@property (nonatomic) int64_t colorType;
@property (nullable, nonatomic, retain) NSNumber *cpuUsageRate;
@property (nullable, nonatomic, retain) NSNumber *diskUtilize;
@property (nullable, nonatomic, retain) NSNumber *diskUsageRate;
@property (nullable, nonatomic, retain) NSNumber *memUsageRate;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *netDownload;
@property (nullable, nonatomic, copy) NSString *netUpload;
@property (nullable, nonatomic, copy) NSString *netUsageRate;
@property (nonatomic) int64_t serverID;
@property (nullable, nonatomic, copy) NSString *netOutputMax;
@property (nullable, nonatomic, copy) NSString *netInputMax;

@end

NS_ASSUME_NONNULL_END
