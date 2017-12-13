//
//  TCSpacingTextField.h
//  功能: 电话号码输入文本框，输入中自动加入分隔符(随意指定符号)
//
//  Created by huangdx on 2017/10/26.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTFIELD_SPACING_MARK   @" "

@class TCSpacingTextField;
typedef void (^SpacingTextFieldFinishBlock)(TCSpacingTextField *textField);

@interface TCSpacingTextField : UITextField

@property (nonatomic, assign)   NSInteger   firstSpacingPosition;   //从0开始计算，第一次分隔的位置
@property (nonatomic, assign)   NSInteger   secondSpacingPosition;
@property (nonatomic, assign)   NSInteger   maxLength;              //号码最大长度
@property (nonatomic, strong)   NSString    *plainPhoneNum;         //去掉格式的电话号码
@property (nonatomic, copy)     SpacingTextFieldFinishBlock     finishBlock;    //达到最大输入长度后被调用

@end
