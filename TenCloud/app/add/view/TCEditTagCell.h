//
//  TCEditTagCell.h
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
typedef NS_ENUM(NSInteger, TCTagEditType){
    TCTagEditTypeFinished   =  0,  //完成编辑
    TCTagEditTypeNew,              //新增标签
    TCTagEditTypeEditing,          //编辑中
    TCTagEditTypeSelected          //选中状态
};
 */

@class TCEditTag;
@interface TCEditTagCell : UICollectionViewCell

//- (void) setName:(NSString*)name;
//@property (nonatomic, weak) IBOutlet    UITextField *textField;

@property (nonatomic, strong)   TCEditTag   *editTag;
//- (void) setEditTag:(TCEditTag*)tag;

//- (void) startEdit;
//- (BOOL) becomeFirstResponder;

@end
