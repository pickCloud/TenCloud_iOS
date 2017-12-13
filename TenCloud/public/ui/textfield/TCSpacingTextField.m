//
//  TCSpacingTextField.m
//  
//
//  Created by huangdx on 2017/10/26.
//  Copyright © 2017年 ye.com. All rights reserved.
//

#import "TCSpacingTextField.h"
@interface TCSpacingTextField() <UITextFieldDelegate>
@end

@implementation TCSpacingTextField

- (id)init
{
    self = [super init];
    if (self)
    {
        _firstSpacingPosition = 4;
        _secondSpacingPosition = 9;
        _maxLength = 8;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _firstSpacingPosition = 4;
        _secondSpacingPosition = 9;
        _maxLength = 8;
    }
    return self;
}

- (NSString *)plainPhoneNum {
    return [self _noneSpaseString:self.text];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *phStr = TEXTFIELD_SPACING_MARK;
    unichar phChar = ' ';
    if (phStr.length) {
        phChar = [phStr characterAtIndex:0];
    }
    
    
    if (textField) {
        NSString* text = textField.text;
        //删除
        if([string isEqualToString:@""]){
            
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length - 1 ) {
                    if ([text characterAtIndex:text.length - 1] == phChar) {
                        [textField deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == phChar && [textField.selectedTextRange isEmpty]) {
                        [textField deleteBackward];
                        offset --;
                    }
                    [textField deleteBackward];
                    textField.text = [self _parseString:textField.text];
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == textField.text.length ){
                    isLast = YES;
                }
                [textField deleteBackward];
                textField.text = [self _parseString:textField.text];
                
                NSInteger offset = range.location;
                if (range.location == _firstSpacingPosition || range.location  == _secondSpacingPosition) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
                    textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        
        else if(string.length >0){
            
            //限制输入字符个数
            NSInteger curLength = [self _noneSpaseString:textField.text].length + string.length - range.length;
            if ( curLength > _maxLength ) {
                return NO;
            }
            
            //判断是否是纯数字(搜狗，百度输入法，数字键盘居然可以输入其他字符)
            if(![self _isNum:string]){
                return NO;
            }
            [textField insertText:string];
            textField.text = [self _parseString:textField.text];
            /*
            NSInteger offset = range.location + string.length;
            if (range.location == _firstSpacingPosition || range.location  == _secondSpacingPosition) {
                offset ++;
            }
            UITextPosition *newPos = [textField positionFromPosition:textField.beginningOfDocument offset:offset];
            textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
            */
            if (curLength == _maxLength)
            {
                if (_finishBlock)
                {
                    _finishBlock(self);
                }
                return NO;
            }
            return NO;
        }else{
            return YES;
        }
        
    }
    
    return YES;
    
    
}

- (NSString*)_parseString:(NSString*)string{
    
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:TEXTFIELD_SPACING_MARK withString:@""]];
    if (mStr.length >_firstSpacingPosition) {
        [mStr insertString:TEXTFIELD_SPACING_MARK atIndex:_firstSpacingPosition];
    }if (mStr.length > _secondSpacingPosition) {
        [mStr insertString:TEXTFIELD_SPACING_MARK atIndex:_secondSpacingPosition];
        
    }
    
    return  mStr;
    
}

/** 获取正常电话号码（去掉空格） */
- (NSString*)_noneSpaseString:(NSString*)string{
    
    return [string stringByReplacingOccurrencesOfString:TEXTFIELD_SPACING_MARK withString:@""];
    
}

- (BOOL)_isNum:(NSString *)checkedNumString {
    
    if (!checkedNumString) {
        return NO;
    }
    
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if(checkedNumString.length > 0) {
        return NO;
    }
    
    return YES;
    
}

@end
