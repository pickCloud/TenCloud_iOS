//
//  TCEmptyPermission.h
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCEmptyPermission : NSObject

+ (instancetype) shared;

- (void) print;

@property (nonatomic, strong)   NSMutableArray  *permissionArray;

@end
