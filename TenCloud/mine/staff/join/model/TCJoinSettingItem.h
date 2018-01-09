//
//  TCJoinSettingItem.h
//  TenCloud
//
//  Created by huangdx on 2018/1/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCJoinSettingItem : NSObject

@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSString    *key;
@property (nonatomic, assign)   BOOL        required;

@end
