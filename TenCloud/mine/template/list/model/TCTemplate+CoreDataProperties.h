//
//  TCTemplate+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTemplate+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCTemplate (CoreDataProperties)

+ (NSFetchRequest<TCTemplate *> *)fetchRequest;

@property (nonatomic) int64_t tid;
@property (nonatomic) int64_t type;
@property (nonatomic) int64_t cid;
@property (nullable, nonatomic, copy) NSString *access_filehub;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *access_projects;
@property (nullable, nonatomic, copy) NSString *permissions;
@property (nullable, nonatomic, copy) NSString *access_servers;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *update_time;

@end

NS_ASSUME_NONNULL_END
