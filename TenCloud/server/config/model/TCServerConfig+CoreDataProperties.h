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

@class TCServerBasicInfo;
@class TCServerBusinessInfo;
@class TCServerSystemInfo;
@interface TCServerConfig (CoreDataProperties)

+ (NSFetchRequest<TCServerConfig *> *)fetchRequest;

@property (nullable, nonatomic, retain) TCServerBasicInfo *basic_info;
@property (nullable, nonatomic, retain) TCServerBusinessInfo *business_info;
@property (nullable, nonatomic, retain) TCServerSystemInfo *system_info;

@end

NS_ASSUME_NONNULL_END
