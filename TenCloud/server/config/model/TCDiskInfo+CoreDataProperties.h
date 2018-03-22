//
//  TCDiskInfo+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCDiskInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCDiskInfo (CoreDataProperties)

+ (NSFetchRequest<TCDiskInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *system_disk_id;
@property (nullable, nonatomic, copy) NSString *system_disk_type;
@property (nullable, nonatomic, copy) NSString *system_disk_size;

@end

NS_ASSUME_NONNULL_END
