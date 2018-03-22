//
//  TCImageInfo+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCImageInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCImageInfo (CoreDataProperties)

+ (NSFetchRequest<TCImageInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *image_name;
@property (nullable, nonatomic, copy) NSString *image_id;
@property (nullable, nonatomic, copy) NSString *image_version;

@end

NS_ASSUME_NONNULL_END
