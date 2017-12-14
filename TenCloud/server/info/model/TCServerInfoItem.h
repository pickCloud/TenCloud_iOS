//
//  TCServerInfoItem.h
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCServerInfoItem : NSObject

- (instancetype) initWithKey:(NSString*)key value:(NSString*)value;

@property (nonatomic, strong)   NSString    *key;
@property (nonatomic, strong)   NSString    *value;

@end
