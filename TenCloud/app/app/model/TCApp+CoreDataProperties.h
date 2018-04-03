//
//  TCApp+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/4/4.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCApp+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCApp (CoreDataProperties)

+ (NSFetchRequest<TCApp *> *)fetchRequest;

@property (nonatomic) int64_t appID;
@property (nullable, nonatomic, copy) NSString *logo_url;
@property (nullable, nonatomic, copy) NSString *create_time;
@property (nullable, nonatomic, retain) NSArray *labels;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t status;
@property (nullable, nonatomic, copy) NSString *update_time;
@property (nullable, nonatomic, copy) NSString *repos_name;
@property (nonatomic) int64_t lord;
@property (nullable, nonatomic, copy) NSString *repos_https_url;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSString *repos_ssh_url;
@property (nonatomic) int64_t form;
@property (nonatomic) int64_t image_id;

@end

NS_ASSUME_NONNULL_END
