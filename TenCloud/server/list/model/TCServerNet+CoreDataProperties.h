//
//  TCServerNet+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerNet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerNet (CoreDataProperties)

+ (NSFetchRequest<TCServerNet *> *)fetchRequest;

@property (nonatomic) int64_t input;
@property (nonatomic) int64_t output;
@property (nonatomic) int64_t created_time;

@end

NS_ASSUME_NONNULL_END
