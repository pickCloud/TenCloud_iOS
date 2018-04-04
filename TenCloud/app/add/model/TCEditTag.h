//
//  TCEditTag.h
//  TenCloud
//
//  Created by huangdx on 2018/4/4.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCTagEditType){
    TCTagEditTypeFinished   =  0,  //完成编辑
    TCTagEditTypeNew,              //新增标签
    TCTagEditTypeEditing,          //编辑中
    TCTagEditTypeSelected          //选中状态
};

@interface TCEditTag : NSObject

@property (nonatomic, assign)   TCTagEditType   type;
@property (nonatomic, strong)   NSString        *name;
@end
