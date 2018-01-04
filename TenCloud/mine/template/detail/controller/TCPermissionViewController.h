//
//  TCPermissionViewController.h
//  权限编辑页面
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCViewController.h"

typedef NS_ENUM(NSInteger, PermissionVCState){
    PermissionVCStateNew   =    0,           //新增状态
    PermissionVCStateEdit,                   //编辑状态
};

@class TCTemplate;
@interface TCPermissionViewController : TCViewController

@property (nonatomic, assign)   PermissionVCState   state;
@property (nonatomic, strong)   TCTemplate          *tmpl;

@end
