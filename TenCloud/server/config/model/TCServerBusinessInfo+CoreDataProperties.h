//
//  TCServerBusinessInfo+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerBusinessInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@class TCServerBusinessContract;
@interface TCServerBusinessInfo (CoreDataProperties)

+ (NSFetchRequest<TCServerBusinessInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *provider;
@property (nullable, nonatomic, retain) TCServerBusinessContract *contract;

@end

NS_ASSUME_NONNULL_END
