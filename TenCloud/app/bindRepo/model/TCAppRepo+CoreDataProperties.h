//
//  TCAppRepo+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/4/10.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCAppRepo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCAppRepo (CoreDataProperties)

+ (NSFetchRequest<TCAppRepo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *repos_name;
@property (nullable, nonatomic, copy) NSString *repos_url;
@property (nullable, nonatomic, copy) NSString *http_url;

@end

NS_ASSUME_NONNULL_END
