//
//  TCConfiguration.h
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCClusterProvider;
@interface TCConfiguration : NSObject

+ (instancetype) shared;

- (void) startFetch;

- (void) stopFetch;

- (void) print;

@property (nonatomic, strong)   NSMutableArray  *providerArray;

@end
