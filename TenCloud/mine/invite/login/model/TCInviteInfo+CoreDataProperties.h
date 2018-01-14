//
//  TCInviteInfo+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/14.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCInviteInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCInviteInfo (CoreDataProperties)

+ (NSFetchRequest<TCInviteInfo *> *)fetchRequest;

@property (nonatomic) int64_t cid;
@property (nullable, nonatomic, copy) NSString *company_name;
@property (nullable, nonatomic, copy) NSString *contact;
@property (nullable, nonatomic, copy) NSString *setting;

@end

NS_ASSUME_NONNULL_END
