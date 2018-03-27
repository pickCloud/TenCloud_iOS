//
//  TCService+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCService+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCService (CoreDataProperties)

+ (NSFetchRequest<TCService *> *)fetchRequest;

@property (nonatomic) int64_t serviceID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSArray *labels;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *clusterIP;
@property (nullable, nonatomic, copy) NSString *loadBalancing;
@property (nullable, nonatomic, copy) NSString *outerIP;
@property (nullable, nonatomic, copy) NSString *port;
@property (nonatomic) int64_t createTime;

@end

NS_ASSUME_NONNULL_END
