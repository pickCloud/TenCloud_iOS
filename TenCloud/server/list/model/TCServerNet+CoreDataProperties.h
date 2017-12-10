//
//  TCServerNet+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/10.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerNet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerNet (CoreDataProperties)

+ (NSFetchRequest<TCServerNet *> *)fetchRequest;

@property (nonatomic) int64_t output;
@property (nonatomic) int64_t intput;

@end

NS_ASSUME_NONNULL_END
