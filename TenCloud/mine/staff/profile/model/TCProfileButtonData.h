//
//  TCProfileButtonData.h
//  TenCloud
//
//  Created by huangdx on 2018/1/7.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCProfileButtonType){
    TCProfileButtonViewPermission   =   0,
    TCProfileButtonSetPermission,
    TCProfileButtonAllowJoin,
    TCProfileButtonRejectJoin,
    TCProfileButtonRemoveStaff,
    TCProfileButtonChangeAdmin
};

@interface TCProfileButtonData : NSObject

@property (nonatomic, strong)   NSString            *title;
@property (nonatomic, strong)   UIColor             *color;
@property (nonatomic, assign)   NSInteger           buttonIndex;
@property (nonatomic, assign)   TCProfileButtonType type;

@end
