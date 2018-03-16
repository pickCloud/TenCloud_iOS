//
//  TCConfiguration.h
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCServerThreshold+CoreDataProperties.h"

@class TCClusterProvider;
@interface TCConfiguration : NSObject

+ (instancetype) shared;

- (void) startFetch;

- (void) stopFetch;

- (void) getServerThreshold;

- (void) print;

@property (nonatomic, strong)   NSMutableArray  *providerArray;
@property (nonatomic, strong)   TCServerThreshold   *threshold;

@end
