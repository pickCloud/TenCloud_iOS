//
//  TCDeploy+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCDeploy+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCDeploy (CoreDataProperties)

+ (NSFetchRequest<TCDeploy *> *)fetchRequest;

@property (nonatomic) int64_t deployID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *status;
@property (nonatomic) int64_t runTime;
@property (nonatomic) int64_t presetPod;
@property (nonatomic) int64_t currentPod;
@property (nonatomic) int64_t updatedPod;
@property (nonatomic) int64_t availablePod;
@property (nonatomic) int64_t createTime;

@end

NS_ASSUME_NONNULL_END
