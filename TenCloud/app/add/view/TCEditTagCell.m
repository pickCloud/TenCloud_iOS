//
//  TCEditTagCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditTagCell.h"
#import "TCEditTag.h"

@interface TCEditTagCell()
@property (nonatomic, strong)   CAShapeLayer        *dashLayer;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
//@property (nonatomic, assign)   TCTagEditType       type;
@end

@implementation TCEditTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = TCSCALE(2.0);
    self.layer.borderWidth = 0.6;
    self.layer.borderColor = THEME_TEXT_COLOR.CGColor;
    _nameLabel.textColor = THEME_TEXT_COLOR;
    self.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = TCFont(12.);
    
    //_textField.textColor = THEME_TEXT_COLOR;
    //_textField.font = TCFont(12.);
}

/*
- (void) setName:(NSString*)name
{
    _nameLabel.text = name;
    if (_type == TCTagEditTypeNew)
    {
        //self.nameLabel.text = @"新增标签";
        _textField.text = @"新增标签";
        self.layer.borderColor = [UIColor clearColor].CGColor;
        //self.backgroundColor = [UIColor clearColor];
        
        CAShapeLayer *border = [CAShapeLayer layer];
        
        border.strokeColor = THEME_TEXT_COLOR.CGColor;
        
        border.fillColor = nil;
        
        border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        border.frame = self.bounds;
        
        border.lineWidth = 1.f;
        
        border.lineCap = @"square";
        
        border.lineDashPattern = @[@4, @4];
        
        [self.layer addSublayer:border];
    }else if(_type == TCTagEditTypeEditing)
    {
        self.nameLabel.text = @"";//name;
        _textField.text = @"";//name;
    }else if(_type == TCTagEditTypeFinished)
    {
        self.nameLabel.text = name;
        self.layer.borderColor = THEME_TEXT_COLOR.CGColor;
        _textField.text = name;
    }else if(_type == TCTagEditTypeSelected)
    {
        self.nameLabel.text = name;
        _textField.text = name;
    }
}

 */

- (void) setEditTag:(TCEditTag*)tag
{
    _nameLabel.text = tag.name;
    if (tag.type == TCTagEditTypeNew)
    {
        //self.nameLabel.text = @"新增标签";
        self.nameLabel.hidden = NO;
        //_textField.text = @"新增标签";
        //_textField.userInteractionEnabled = NO;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        //self.backgroundColor = [UIColor clearColor];
        
        CAShapeLayer *border = [CAShapeLayer layer];
        _dashLayer = border;
        
        border.strokeColor = THEME_TEXT_COLOR.CGColor;
        
        border.fillColor = nil;
        
        border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        border.frame = self.bounds;
        
        border.lineWidth = 1.f;
        
        border.lineCap = @"square";
        
        border.lineDashPattern = @[@4, @4];
        
        [self.layer addSublayer:border];
    }else if(tag.type == TCTagEditTypeEditing)
    {
        self.nameLabel.hidden = YES;
        self.nameLabel.text = @"";//name;
        //_textField.text = @"";//name;
        //_textField.userInteractionEnabled = YES;
    }else if(tag.type == TCTagEditTypeFinished)
    {
        if (_dashLayer)
        {
            [_dashLayer removeFromSuperlayer];
        }
        self.nameLabel.hidden = NO;
        self.nameLabel.text = tag.name;
        self.layer.borderColor = THEME_TEXT_COLOR.CGColor;
        //_textField.text = tag.name;
        //_textField.userInteractionEnabled = NO;
    }else if(tag.type == TCTagEditTypeSelected)
    {
        if (_dashLayer)
        {
            [_dashLayer removeFromSuperlayer];
        }
        self.nameLabel.hidden = NO;
        self.nameLabel.text = tag.name;
        //_textField.text = tag.name;
        //_textField.userInteractionEnabled = NO;
    }
}

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    /*
    if (self.selected)
    {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        _nameLabel.textColor = THEME_TINT_COLOR;
        self.backgroundColor = STATE_NORMAL_BG_COLOR;
    }else
    {
        self.layer.borderColor = THEME_PLACEHOLDER_COLOR.CGColor;
        _nameLabel.textColor = THEME_PLACEHOLDER_COLOR;
        self.backgroundColor = [UIColor clearColor];
    }
     */
}

/*
- (BOOL) becomeFirstResponder
{
    [super becomeFirstResponder];
    return [_textField becomeFirstResponder];
}
 */
@end
