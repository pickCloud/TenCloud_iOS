//
//  TCTemplateChunk+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCTemplateChunk+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCTemplateChunk (CoreDataProperties)

+ (NSFetchRequest<TCTemplateChunk *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSObject *data;

@end

NS_ASSUME_NONNULL_END
