//
//  TCServerConfig+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerConfig+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerConfig *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *basic_info;
@property (nullable, nonatomic, retain) NSObject *business_info;
@property (nullable, nonatomic, retain) NSObject *system_info;

@end

NS_ASSUME_NONNULL_END
