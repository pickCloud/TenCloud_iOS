//
//  TCServerBusinessContract+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/29.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerBusinessContract+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerBusinessContract (CoreDataProperties)

+ (NSFetchRequest<TCServerBusinessContract *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *charge_type;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *expired_time;
@property (nullable, nonatomic, copy) NSString *instance_charge_type;
@property (nullable, nonatomic, copy) NSString *instance_internet_charge_type;

@end

NS_ASSUME_NONNULL_END
