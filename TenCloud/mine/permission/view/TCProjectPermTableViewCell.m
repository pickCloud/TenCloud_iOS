//
//  TCProjectPermTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCProjectPermTableViewCell.h"
#import "TCPermissionNode+CoreDataClass.h"

@interface TCProjectPermTableViewCell ()
//@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
//@property (nonatomic, weak) IBOutlet    UIImageView *iconView;
@property (nonatomic, weak) IBOutlet    UIView      *bg2View;

- (void) updateUI;
@end

@implementation TCProjectPermTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bg2View.layer.cornerRadius = TCSCALE(2.0);
    
    self.nameLabel.font = TCFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self updateUI];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    NSLog(@"highlighted:%d",highlighted);
    [self updateUI];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    //[self updateUI];
}

- (void) setNode:(TCPermissionNode *)node
{
    [super setNode:node];
    //self.nameLabel.text = node.filename;
    if (self.editable)
    {
        //[_checkButton setHidden:NO];
        //_leftConstraint.constant = 18 + (_mNode.depth - 1) * 23;
        self.leftConstraint.constant = 8;
    }else
    {
        //[_checkButton setHidden:YES];
        //_leftConstraint.constant = -4 + (_mNode.depth - 1) * 23;
        self.leftConstraint.constant = -4;
    }
}

- (void) updateUI
{
    /*
    if (self.selected)
    {
        self.bg2View.backgroundColor = [UIColor redColor]; //TABLE_CELL_BG_COLOR;
        NSLog(@"变红");
    }else
    {
        self.bg2View.backgroundColor = TABLE_CELL_BG_COLOR;
        NSLog(@"不变红");
    }
     */
    if (self.highlighted)
    {
        self.bg2View.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
        NSLog(@"变红");
    }else
    {
        self.bg2View.backgroundColor = TABLE_CELL_BG_COLOR;
        NSLog(@"不变红");
    }
}

- (void) updateCheckButtonUI
{
    if (self.mNode.selected && self.editable)
    {
        UIImage *selectedImage = [UIImage imageNamed:@"template_checked"];
        [self.checkButton setImage:selectedImage forState:UIControlStateNormal];
        self.nameLabel.textColor = THEME_TINT_COLOR;
        //NSString *iconName = @"perm_file_doc_s";
        //UIImage *iconImg = [UIImage imageNamed:iconName];
        //[_iconView setImage:iconImg];
    }else
    {
        UIImage *unselectedImage = [UIImage imageNamed:@"template_unchecked"];
        [self.checkButton setImage:unselectedImage forState:UIControlStateNormal];
        self.nameLabel.textColor = THEME_TEXT_COLOR;
        //NSString *iconName = @"perm_file_doc";
        //UIImage *iconImg = [UIImage imageNamed:iconName];
        //[_iconView setImage:iconImg];
    }
}

@end
