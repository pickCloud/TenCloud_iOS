//
//  NSManagedObject+Clone.m
//  TenCloud
//
//  Created by huangdx on 2018/1/19.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "NSManagedObject+Clone.h"

@implementation NSManagedObject (Clone)

- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context withCopiedCache:(NSMutableDictionary *)alreadyCopied exludeEntities:(NSArray *)namesOfEntitiesToExclude {
    NSString *entityName = [[self entity] name];
    
    if ([namesOfEntitiesToExclude containsObject:entityName]) {
        return nil;
    }
    
    NSManagedObject *cloned = [alreadyCopied objectForKey:[self objectID]];
    if (cloned != nil) {
        return cloned;
    }
    
    //create new object in data store
    cloned = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    [alreadyCopied setObject:cloned forKey:[self objectID]];
    
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription entityForName:entityName inManagedObjectContext:context] attributesByName];
    
    for (NSString *attr in attributes) {
        NSObject *oldObj = [self valueForKey:attr];
        if ([oldObj isKindOfClass:[NSArray class]])
        {
            NSArray *oldArray = (NSArray*)oldObj;
            NSMutableArray *newArray = [NSMutableArray new];
            for (NSManagedObject * tmpManagedObj in oldArray)
            {
                NSManagedObject *newManagedObj = [tmpManagedObj cloneInContext:context exludeEntities:@[]];
                [newArray addObject:newManagedObj];
            }
            [cloned setValue:newArray forKey:attr];
        }else if([oldObj isKindOfClass:[NSNumber class]])
        {
            NSNumber *newNum = [(NSNumber*)oldObj copy];
            [cloned setValue:newNum forKey:attr];
        }else if([oldObj isKindOfClass:[NSString class]])
        {
            NSString *newStr = [(NSString*)oldObj copy];
            [cloned setValue:newStr forKey:attr];
        }
        else
        {
            NSManagedObject *newObj = [(NSManagedObject*)oldObj cloneInContext:context exludeEntities:@[]];
            [cloned setValue:newObj forKey:attr];
        }
        //NSManagedObject *newObj = [oldObj cloneInContext:context exludeEntities:@[]];
        //[cloned setValue:newObj forKey:attr];
         /*
        [cloned setValue:[self valueForKey:attr] forKey:attr];
         */
    }
    
    //Loop through all relationships, and clone them.
    NSDictionary *relationships = [[NSEntityDescription entityForName:entityName inManagedObjectContext:context] relationshipsByName];
    for (NSString *relName in [relationships allKeys]){
        NSRelationshipDescription *rel = [relationships objectForKey:relName];
        
        NSString *keyName = rel.name;
        if ([rel isToMany]) {
            //get a set of all objects in the relationship
            NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
            NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
            NSEnumerator *e = [sourceSet objectEnumerator];
            NSManagedObject *relatedObject;
            while ( relatedObject = [e nextObject]){
                //Clone it, and add clone to set
                NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
                [clonedSet addObject:clonedRelatedObject];
            }
        }else {
            NSManagedObject *relatedObject = [self valueForKey:keyName];
            if (relatedObject != nil) {
                NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context withCopiedCache:alreadyCopied exludeEntities:namesOfEntitiesToExclude];
                [cloned setValue:clonedRelatedObject forKey:keyName];
            }
        }
    }
    
    return cloned;
}

- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context exludeEntities:(NSArray *)namesOfEntitiesToExclude {
    return [self cloneInContext:context withCopiedCache:[NSMutableDictionary dictionary] exludeEntities:namesOfEntitiesToExclude];
}

@end
