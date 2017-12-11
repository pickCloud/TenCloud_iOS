//
//  TCServerLog+CoreDataProperties.h
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//
//

#import "TCServerLog+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ServerLogOperation){
    ServerLogOperationPowerOn   =   0,
    ServerLogOperationRestart,
    ServerLogOperationPowerOff
};

typedef NS_ENUM(NSInteger, ServerLogOperationStatus){
    ServerLogOperationStatusSuccess =   0,
    ServerLogOperationStatusFail
};

@interface TCServerLog (CoreDataProperties)

+ (NSFetchRequest<TCServerLog *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *create_time;
@property (nonatomic) ServerLogOperationStatus operation_status;
@property (nullable, nonatomic, copy) NSString *user;
@property (nonatomic) ServerLogOperation operation;

@end

NS_ASSUME_NONNULL_END
