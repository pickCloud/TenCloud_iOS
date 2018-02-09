//
//  TCServerInfoItem.h
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCInfoCellType){
    TCInfoCellTypeNormal   =   0,
    TCInfoCellTypeStateLabel
};

@interface TCServerInfoItem : NSObject

- (instancetype) initWithKey:(NSString*)key value:(NSString*)value;
- (instancetype) initWithKey:(NSString*)key value:(NSString*)value type:(TCInfoCellType)type;
- (instancetype) initWithKey:(NSString *)key value:(NSString *)value disclosure:(BOOL)disclosure;

@property (nonatomic, strong)   NSString        *key;
@property (nonatomic, strong)   NSString        *value;
@property (nonatomic, assign)   BOOL            disclosure;
@property (nonatomic, assign)   TCInfoCellType  cellType;

@end
