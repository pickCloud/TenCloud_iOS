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
@property (nonatomic, weak) IBOutlet    UIImageView    *arrowView;
@property (nonatomic, assign)   BOOL                arrowAnimating;
- (IBAction) onSelectButton:(id)sender;
- (IBAction) onFoldButton:(id)sender;
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
    if (_mNode.data && _mNode.data.count > 0)
    {
        _arrowView.hidden = NO;
    }else
    {
        _arrowView.hidden = YES;
    }
    [self updateCheckButtonUI];
    if (_editable)
    {
        [_checkButton setHidden:NO];
        _leftConstraint.constant = 18 + (_mNode.depth - 1) * 23;
    }else
    {
        [_checkButton setHidden:YES];
        _leftConstraint.constant = -4 + (_mNode.depth - 1) * 23;
    }
    if (!_mNode.fold)
    {
        _arrowView.transform = CGAffineTransformIdentity;
    }else
    {
        _arrowView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180.0f));
    }
}

- (void) updateCheckButtonUI
{
    if (self.mNode.selected && _editable)
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
    if (!_editable)
    {
        return;
    }
    self.mNode.selected = !self.mNode.selected;
    [self updateCheckButtonUI];
    
    if (self.selectBlock)
    {
        self.selectBlock(self, self.mNode.selected);
    }
}

- (IBAction) onFoldButton:(id)sender
{
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
