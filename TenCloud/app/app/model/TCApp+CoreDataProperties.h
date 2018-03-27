//
//  TCApp+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/26.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCApp+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCApp (CoreDataProperties)

+ (NSFetchRequest<TCApp *> *)fetchRequest;

@property (nonatomic) int64_t appID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSArray *labels;
@property (nullable, nonatomic, copy) NSString *source;
@property (nonatomic) int64_t createTime;
@property (nonatomic) int64_t updateTime;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
