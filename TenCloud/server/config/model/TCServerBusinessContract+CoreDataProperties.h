//
//  TCServerBusinessContract+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerBusinessContract+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerBusinessContract (CoreDataProperties)

+ (NSFetchRequest<TCServerBusinessContract *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *charge_type;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, copy) NSString *expired_time;

@end

NS_ASSUME_NONNULL_END
