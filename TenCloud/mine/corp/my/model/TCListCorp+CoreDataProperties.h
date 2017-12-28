//
//  TCListCorp+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCListCorp+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCListCorp (CoreDataProperties)

+ (NSFetchRequest<TCListCorp *> *)fetchRequest;

@property (nonatomic) int64_t cid;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *update_time;
@property (nonatomic) int16_t is_admin;

@end

NS_ASSUME_NONNULL_END
