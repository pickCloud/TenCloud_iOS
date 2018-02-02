//
//  TCServerSummary+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/2/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCServerSummary+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCServerSummary (CoreDataProperties)

+ (NSFetchRequest<TCServerSummary *> *)fetchRequest;

@property (nonatomic) int64_t server_num;
@property (nonatomic) int64_t warn_num;
@property (nonatomic) int64_t payment_num;

@end

NS_ASSUME_NONNULL_END
