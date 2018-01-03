//
//  TCEditingTemplate.h
//  TenCloud
//
//  Created by huangdx on 2018/1/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCEditingTemplate : NSObject

+ (instancetype) shared;

- (void) reset;

@property (nonatomic, strong)   NSMutableArray  *permissionSegArray;

- (NSInteger) funcPermissionAmount;

- (NSInteger) dataPermissionAmount;

- (NSArray *)permissionIDArray;

- (NSArray *)serverPermissionIDArray;

- (NSArray *)projectPermissionIDArray;

- (NSArray *)filePermissionIDArray;

@end
