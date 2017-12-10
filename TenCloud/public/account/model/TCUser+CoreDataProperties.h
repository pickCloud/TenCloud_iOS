//
//  TCUser+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCUser (CoreDataProperties)

+ (NSFetchRequest<TCUser *> *)fetchRequest;

@property (nonatomic) int64_t birthday;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *email;
@property (nonatomic) int16_t gender;
@property (nullable, nonatomic, copy) NSString *mobile;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *update_time;
@property (nonatomic) int64_t userID;
@property (nullable, nonatomic, copy) NSString *image_url;

@end

NS_ASSUME_NONNULL_END
