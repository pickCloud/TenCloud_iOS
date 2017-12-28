//
//  TCCorp+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCCorp+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCCorp (CoreDataProperties)

+ (NSFetchRequest<TCCorp *> *)fetchRequest;

@property (nonatomic) int64_t cid;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, copy) NSString *contact;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nonatomic) int16_t is_admin;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *update_time;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
