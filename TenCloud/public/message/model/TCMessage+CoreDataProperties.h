//
//  TCMessage+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/16.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCMessage (CoreDataProperties)

+ (NSFetchRequest<TCMessage *> *)fetchRequest;

@property (nonatomic) int64_t owner;
@property (nonatomic) int64_t mode;
@property (nullable, nonatomic, copy) NSString *update_time;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *tip;
@property (nonatomic) int64_t messageID;
@property (nonatomic) int64_t sub_mode;
@property (nullable, nonatomic, copy) NSString *content;
@property (nonatomic) int64_t status;

@end

NS_ASSUME_NONNULL_END
