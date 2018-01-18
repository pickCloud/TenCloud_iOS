//
//  TCListCorp+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/18.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCListCorp+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCListCorp (CoreDataProperties)

+ (NSFetchRequest<TCListCorp *> *)fetchRequest;

@property (nonatomic) int64_t cid;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nonatomic) int16_t is_admin;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *update_time;
@property (nullable, nonatomic, copy) NSString *code;

@end

NS_ASSUME_NONNULL_END
