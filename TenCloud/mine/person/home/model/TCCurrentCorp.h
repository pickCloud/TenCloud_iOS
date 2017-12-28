//
//  TCCurrentCorp.h
//  TenCloud
//
//  Created by huangdx on 2017/12/28.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCCorp;
@interface TCCurrentCorp : NSObject

+ (instancetype) shared;

@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, assign)   NSInteger   cid;

- (BOOL) isCurrent:(TCCorp*)corp;

@end
