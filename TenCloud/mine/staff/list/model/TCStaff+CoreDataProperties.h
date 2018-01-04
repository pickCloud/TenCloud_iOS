//
//  TCStaff+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/4.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCStaff+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCStaff (CoreDataProperties)

+ (NSFetchRequest<TCStaff *> *)fetchRequest;

@property (nonatomic) int16_t is_admin;
@property (nonatomic) int64_t uid;
@property (nullable, nonatomic, copy) NSString *update_time;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t staffID;
@property (nonatomic) int64_t status;

@end

NS_ASSUME_NONNULL_END
