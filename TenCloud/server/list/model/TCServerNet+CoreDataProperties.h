//
//  TCServerNet+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerNet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerNet (CoreDataProperties)

+ (NSFetchRequest<TCServerNet *> *)fetchRequest;

@property (nonatomic) int64_t input;
@property (nonatomic) int64_t output;

@end

NS_ASSUME_NONNULL_END
