//
//  TCEditCellData.h
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EditCellType) {
    EditCellTypeText    =   0,
    EditCellTypeDate,
    EditCellTypeGender,
    EditCellTypeAvatar,
    EditCellTypeIDCard
};

@interface TCEditCellData : NSObject

@property (nonatomic, assign)   EditCellType    type;
@property (nonatomic, strong)   NSString        *title;
@property (nonatomic, strong)   NSString        *editPageTitle;
@property (nonatomic, strong)   id              initialValue;
@property (nonatomic, strong)   id              value;

@end
