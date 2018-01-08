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
    PermissionVCPreviewPermission,           //查看状态
    PermissionVCModifyUserPermission         //修改用户权限
};

@class TCPermissionViewController;
typedef void (^TCPermissionModifiedBlock)(TCPermissionViewController *vc);

@class TCTemplate;
@interface TCPermissionViewController : TCViewController

@property (nonatomic, assign)   PermissionVCState   state;
@property (nonatomic, strong)   TCTemplate          *tmpl;
@property (nonatomic, assign)   NSInteger           userID;
@property (nonatomic, copy)     TCPermissionModifiedBlock   modifiedBlock;
@end
