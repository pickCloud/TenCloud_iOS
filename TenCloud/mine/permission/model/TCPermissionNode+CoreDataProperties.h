//
//  TCPermissionNode+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2018/2/7.
//  Copyright © 2018年 10.com. All rights reserved.
//
//

#import "TCPermissionNode+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TCPermissionNode (CoreDataProperties)

+ (NSFetchRequest<TCPermissionNode *> *)fetchRequest;

- (NSInteger) subNodeAmount;

- (NSInteger) subLeafNodeAmount;

- (TCPermissionNode*) subNodeAtIndex:(NSInteger)index;

//- (void) setFatherNodeSelectedAfterSubNodesAllSelected;

- (void) updateFatherNodeAfterSubNodeChanged;

- (void) updateSubNodesAfterFatherNodeChanged;

- (NSArray*)selectedServerSubNodeIDArray;

- (NSArray*)selectedSubNodeIDArray;

- (void) print;

@property (nullable, nonatomic, retain) NSMutableArray<TCPermissionNode*> *data;
@property (nonatomic) int64_t depth;
@property (nullable, nonatomic, retain) TCPermissionNode *fatherNode;
@property (nullable, nonatomic, copy) NSString *filename;
@property (nonatomic) BOOL fold;
@property (nonatomic) BOOL hidden;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t permID;
@property (nullable, nonatomic, copy) NSString *provider;
@property (nullable, nonatomic, copy) NSString *public_ip;
@property (nullable, nonatomic, copy) NSString *region_name;
@property (nonatomic) BOOL selected;
@property (nonatomic) int64_t sid;
@property (nullable, nonatomic, copy) NSString *status;
@property (nonatomic) int64_t type;
@property (nullable, nonatomic, copy) NSString *mime;

@end

NS_ASSUME_NONNULL_END
