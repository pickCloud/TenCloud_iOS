//
//  TCEmptyPermission.h
//  功能:未设置过的公司权限数据
//  因服务端返回的权限数据不合理，导致客户端需要通过这个类，把权限id列表恢复成权限数据
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCEmptyPermission : NSObject

+ (instancetype) shared;

- (void) reset;

//- (void) print;

@property (nonatomic, strong)   NSMutableArray  *permissionArray;

@end
