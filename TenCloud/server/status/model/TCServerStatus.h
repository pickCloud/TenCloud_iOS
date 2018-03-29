//
//  TCServerStatus.h
//  TenCloud
//
//  Created by huangdx on 2018/3/21.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCServerActionType){
    TCServerActionReboot   =   0,  //重启
    TCServerActionStart,           //开机
    TCServerActionStop,            //关机
};


@class TCServerStatus;
@protocol TCServerStatusDelegate<NSObject>
- (void) serverWithID:(NSInteger)serverID statusChanged:(NSString*)newStatus;
@end

@interface TCServerStatus : NSObject

@property (nonatomic, assign)   NSInteger           serverID;
@property (nonatomic, strong)   NSString            *instanceID;
@property (nonatomic, strong)   NSString            *status;
@property (nonatomic, assign)   TCServerActionType  actionType;

- (void) addObserver:(id<TCServerStatusDelegate>)obs;
- (void) removeObserver:(id<TCServerStatusDelegate>)obs;

- (void) reboot;
- (void) start;
- (void) stop;

@end
