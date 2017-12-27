//
//  TCCellData.h
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCCellType) {
    TCCellTypeEditText    =   0,
    TCCellTypeEditDate,
    TCCellTypeEditGender,
    TCCellTypeEditAvatar,
    TCCellTypeEditIDCard,
    TCCellTypeText,
};

@interface TCCellData : NSObject

@property (nonatomic, assign)   TCCellType      type;
@property (nonatomic, strong)   NSString        *title;
@property (nonatomic, strong)   NSString        *editPageTitle;
@property (nonatomic, strong)   id              initialValue;
@property (nonatomic, strong)   id              value;
@property (nonatomic, strong)   NSString        *keyName;
@property (nonatomic, assign)   BOOL            hideDetailView;

@end
