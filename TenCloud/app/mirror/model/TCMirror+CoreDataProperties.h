//
//  TCMirror+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/3/28.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCMirror+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCMirror (CoreDataProperties)

+ (NSFetchRequest<TCMirror *> *)fetchRequest;

@property (nonatomic) int64_t mirrorID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *version;
@property (nonatomic) int64_t updateTime;

@end

NS_ASSUME_NONNULL_END
