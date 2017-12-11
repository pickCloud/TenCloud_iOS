//
//  TCServerCPU+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerCPU+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerCPU (CoreDataProperties)

+ (NSFetchRequest<TCServerCPU *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSNumber *percent;

@end

NS_ASSUME_NONNULL_END
