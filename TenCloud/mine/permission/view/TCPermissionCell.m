//
//  TCPermissionCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPermissionCell.h"
#import "TCPermissionNode+CoreDataClass.h"
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface TCPermissionCell()
@property (nonatomic, weak) TCPermissionNode        *mNode;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *checkButton;
@property (nonatomic, weak) IBOutlet    UIImageView    *arrowView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *leftConstraint;
@property (nonatomic, assign)   BOOL                arrowAnimating;
- (IBAction) onSelectButton:(id)sender;
- (IBAction) onFoldButton:(id)sender;
- (void) updateCheckButtonUI;
@end

@implementation TCPermissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setNode:(TCPermissionNode *)node
{
    _mNode = node;
    if (node.name)
    {
        _nameLabel.text = node.name;
    }else
    {
        _nameLabel.text = node.filename;
    }
    _leftConstraint.constant = _mNode.depth * 25;
    if (_mNode.data && _mNode.data.count > 0)
    {
        _arrowView.hidden = NO;
    }else
    {
        _arrowView.hidden = YES;
    }
    [self updateCheckButtonUI];
}

- (void) updateCheckButtonUI
{
    if (self.mNode.selected)
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
    self.mNode.selected = !self.mNode.selected;
    [self updateCheckButtonUI];
    
    if (self.selectBlock)
    {
        self.selectBlock(self, self.mNode.selected);
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
        if (self.mNode.fold)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.arrowView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                weakSelf.arrowAnimating = NO;
                weakSelf.mNode.fold = NO;
            }];
        }else
        {
            [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionCurveLinear animations:^{
                weakSelf.arrowView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180.0f));
            } completion:^(BOOL finished) {
                weakSelf.arrowAnimating = NO;
                weakSelf.mNode.fold = YES;
            }];
        }
        if (_foldBlock)
        {
            _foldBlock(self,!self.mNode.fold);
        }
    }
}
@end
