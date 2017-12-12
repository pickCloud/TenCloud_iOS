//
//  TCServerSystemInfo+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerSystemInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class TCServerSystemConfig;
@interface TCServerSystemInfo (CoreDataProperties)

+ (NSFetchRequest<TCServerSystemInfo *> *)fetchRequest;

@property (nullable, nonatomic, retain) TCServerSystemConfig *config;

@end

NS_ASSUME_NONNULL_END
