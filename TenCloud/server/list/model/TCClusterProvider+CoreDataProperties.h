//
//  TCClusterProvider+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCClusterProvider+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCClusterProvider (CoreDataProperties)

+ (NSFetchRequest<TCClusterProvider *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *provider;
@property (nullable, nonatomic, retain) NSArray *regions;

@end

NS_ASSUME_NONNULL_END
