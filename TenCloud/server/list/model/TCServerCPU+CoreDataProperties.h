//
//  TCServerCPU+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerCPU+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerCPU (CoreDataProperties)

+ (NSFetchRequest<TCServerCPU *> *)fetchRequest;

@property (nonatomic) int64_t percent;

@end

NS_ASSUME_NONNULL_END
