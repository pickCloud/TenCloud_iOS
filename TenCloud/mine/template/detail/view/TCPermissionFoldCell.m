//
//  TCPermissionFoldCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPermissionFoldCell.h"
#import "TCPermissionNode+CoreDataClass.h"
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface TCPermissionFoldCell()
@property (nonatomic, weak) TCPermissionNode        *node;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *checkButton;
@property (nonatomic, weak) IBOutlet    UIImageView    *arrowView;
@property (nonatomic, assign)   BOOL                arrowAnimating;
- (IBAction) onSelectButton:(id)sender;
- (IBAction) onFoldButton:(id)sender;
- (void) updateCheckButtonUI;
@end

@implementation TCPermissionFoldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
- (void) setData:(TCCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    NSString *descText = data.initialValue;
    if (descText == nil || descText.length == 0)
    {
        descText = @"未设置";
    }
    self.descLabel.text = descText;//data.initialValue;
}
 */

- (void) setNode:(TCPermissionNode *)node
{
    _nameLabel.text = node.name;
    _node = node;
    [self updateCheckButtonUI];
}

- (void) updateCheckButtonUI
{
    if (self.node.selected)
    {
        UIImage *selectedImage = [UIImage imageNamed:@"template_checked"];
        [_checkButton setImage:selectedImage forState:UIControlStateNormal];
        _nameLabel.textColor = THEME_TINT_COLOR;
    }else
    {
        UIImage *unselectedImage = [UIImage imageNamed:@"template_unchecked"];
        [_checkButton setImage:unselectedImage forState:UIControlStateNormal];
        _nameLabel.textColor = THEME_TEXT_COLOR;
    }
}

- (IBAction) onSelectButton:(id)sender
{
    NSLog(@"select button");
    self.node.selected = !self.node.selected;
    [self updateCheckButtonUI];
    
    /*
    if (_selectBlock)
    {
        _selectBlock(self, self.chunk.selected);
    }
     */
    if (self.selectBlock)
    {
        self.selectBlock(self, self.node.selected);
    }
}

- (IBAction) onFoldButton:(id)sender
{
    NSLog(@"fold button");
    /*
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    if (self.chunk.fold)
    {
        CATransform3D from = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
        animation.fromValue = [NSValue valueWithCATransform3D:from];
        CATransform3D to = CATransform3DMakeRotation(0, 0, 0, 1);
        animation.toValue = [NSValue valueWithCATransform3D:to];
        //animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    }else
    {
        CATransform3D from = CATransform3DMakeRotation(0, 0, 0, 1);
        animation.fromValue = [NSValue valueWithCATransform3D:from];
        CATransform3D to = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
        animation.toValue = [NSValue valueWithCATransform3D:to];
    }
    animation.duration = 0.28;
    animation.cumulative = YES;
    [_arrowView.layer addAnimation:animation forKey:@"rotation"];
     */
    if (!_arrowAnimating)
    {
        _arrowAnimating = YES;
        __weak __typeof(self) weakSelf = self;
        if (self.node.fold)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.arrowView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                weakSelf.arrowAnimating = NO;
                weakSelf.node.fold = NO;
            }];
        }else
        {
            [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.arrowView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180.0f));
            } completion:^(BOOL finished) {
                weakSelf.arrowAnimating = NO;
                weakSelf.node.fold = YES;
            }];
        }
        if (_foldBlock)
        {
            _foldBlock(self,!self.node.fold);
        }
    }
}
@end
