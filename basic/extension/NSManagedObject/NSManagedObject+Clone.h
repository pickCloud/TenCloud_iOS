//
//  NSManagedObject+Clone.h
//  TenCloud
//
//  Created by huangdx on 2018/1/19.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Clone)

- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context exludeEntities:(NSArray *)namesOfEntitiesToExclude;

@end
