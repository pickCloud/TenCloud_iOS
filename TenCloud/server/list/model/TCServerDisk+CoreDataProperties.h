//
//  TCServerDisk+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerDisk+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerDisk (CoreDataProperties)

+ (NSFetchRequest<TCServerDisk *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSNumber *total;
@property (nullable, nonatomic, retain) NSNumber *free;
@property (nullable, nonatomic, retain) NSNumber *percent;

@end

NS_ASSUME_NONNULL_END
