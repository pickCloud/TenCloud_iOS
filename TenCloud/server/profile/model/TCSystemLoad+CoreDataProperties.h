//
//  TCSystemLoad+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/29.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCSystemLoad+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class TCServerUsage;
@interface TCSystemLoad (CoreDataProperties)

+ (NSFetchRequest<TCSystemLoad *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;
@property (nonatomic) double fifth_minute_load;
@property (nonatomic) double five_minute_load;
@property (nonatomic) int64_t login_users;
@property (nonatomic) double one_minute_load;
@property (nullable, nonatomic, copy) NSString *run_time;
@property (nullable, nonatomic, retain) TCServerUsage *monitor;

@end

NS_ASSUME_NONNULL_END
