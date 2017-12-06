//
//  TCUser+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCUser (CoreDataProperties)

+ (NSFetchRequest<TCUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
