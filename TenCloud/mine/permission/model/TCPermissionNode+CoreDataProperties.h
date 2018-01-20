//
//  TCPermissionNode+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/1/5.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionNode+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCPermissionNode (CoreDataProperties)

+ (NSFetchRequest<TCPermissionNode *> *)fetchRequest;

- (NSInteger) subNodeAmount;

- (TCPermissionNode*) subNodeAtIndex:(NSInteger)index;

//- (void) setFatherNodeSelectedAfterSubNodesAllSelected;

- (void) updateFatherNodeAfterSubNodeChanged;

- (void) updateSubNodesAfterFatherNodeChanged;

- (NSArray*)selectedSubNodeIDArray;

- (void) print;

@property (nonatomic) int64_t permID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *filename;
@property (nullable, nonatomic, retain) NSMutableArray<TCPermissionNode*> *data;
@property (nonatomic) int64_t depth;
@property (nonatomic) BOOL fold;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL hidden;
@property (nullable, nonatomic, retain) TCPermissionNode *fatherNode;

@end

NS_ASSUME_NONNULL_END
