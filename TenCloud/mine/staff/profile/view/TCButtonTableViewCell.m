//
//  TCButtonTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2018/1/7.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCButtonTableViewCell.h"
@interface TCButtonTableViewCell ()
@property (nonatomic, weak) IBOutlet    UIButton    *button;
@property (nonatomic, weak)     TCProfileButtonData *data;
- (IBAction) onButton:(id)sender;
@end

@implementation TCButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _button.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(TCProfileButtonData*)data
{
    _data = data;
    [_button setTitle:data.title forState:UIControlStateNormal];
    [_button setBackgroundColor:data.color];
}

- (IBAction) onButton:(id)sender
{
    NSLog(@"on button");
    if (_touchedBlock)
    {
        _touchedBlock(self, _data.buttonIndex, _data.type);
    }
    
}
@end