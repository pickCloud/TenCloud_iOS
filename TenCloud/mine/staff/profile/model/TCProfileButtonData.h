//
//  TCProfileButtonData.h
//  TenCloud
//
//  Created by huangdx on 2018/1/7.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCProfileButtonType){
    TCProfileButtonViewPermission   =   0,  //查看权限
    TCProfileButtonSetPermission,           //设置权限
    TCProfileButtonAllowJoin,               //允许加入
    TCProfileButtonRejectJoin,              //拒绝加入
    TCProfileButtonRemoveStaff,             //解除关系
    TCProfileButtonChangeAdmin,             //更换管理员
    TCProfileButtonLeaveCorp,               //离开企业
    
    TCServerButtonStart,                    //开启主机
    TCServerButtonRestart,                  //重启主机
    TCServerButtonStop,                     //关闭主机
    TCServerButtonDelete,                   //删除主机
};

@interface TCProfileButtonData : NSObject

@property (nonatomic, strong)   NSString            *title;
@property (nonatomic, strong)   UIColor             *color;
@property (nonatomic, assign)   NSInteger           buttonIndex;
@property (nonatomic, assign)   TCProfileButtonType type;

@end
