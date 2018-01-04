//
//  TCEditingTemplate.h
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCTemplate;
@interface TCEditingTemplate : NSObject

+ (instancetype) shared;

- (void) reset;

- (void) setTemplate:(TCTemplate*)tmpl;

@property (nonatomic, strong)   NSMutableArray  *permissionSegArray;

- (NSInteger) funcPermissionAmount;

- (NSInteger) dataPermissionAmount;

- (NSArray *)permissionIDArray;

- (NSString *)permissionIDString;

- (NSArray *)serverPermissionIDArray;

- (NSString *)serverPermissionIDString;

- (NSArray *)projectPermissionIDArray;

- (NSString *)projectPermissionIDString;

- (NSArray *)filePermissionIDArray;

- (NSString *)filePermissionIDString;

@end
