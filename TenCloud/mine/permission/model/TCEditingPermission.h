//
//  TCEditingPermission.h
//  功能:保存编辑中的权限数据
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCEditingPermission;
@protocol TCEditingPermissionDelegate<NSObject>
- (void) editingPermission:(TCEditingPermission* )perm selectedAmountChanged:(NSInteger)amount;
@end

@class TCTemplate;
@interface TCEditingPermission : NSObject

@property (nonatomic, copy) NSMutableArray      *permissionArray;

+ (instancetype) shared;

- (void) reset;

- (void) resetForAdmin;

- (void) setTemplate:(TCTemplate*)tmpl;

- (void) readyForPreview;

- (NSInteger) funcPermissionAmount;

- (NSInteger) dataPermissionAmount;

- (void) addObserver:(id<TCEditingPermissionDelegate>)obs;

- (void) removeObserver:(id<TCEditingPermissionDelegate>)obs;

- (void) selectedAmountChanged;

- (NSArray *)permissionIDArray;

- (NSString *)permissionIDString;

- (NSArray *)serverPermissionIDArray;

- (NSString *)serverPermissionIDString;

- (NSArray *)projectPermissionIDArray;

- (NSString *)projectPermissionIDString;

- (NSArray *)filePermissionIDArray;

- (NSString *)filePermissionIDString;

@end
