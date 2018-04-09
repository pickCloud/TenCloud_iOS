//
//  SBASelectServerTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBASelectServerTableViewCell.h"
#import "TCAddingServer+CoreDataClass.h"

@interface SBASelectServerTableViewCell()
@property (nonatomic, strong)   TCAddingServer      *server;
@property (nonatomic, weak) IBOutlet    UIImageView *selectedView;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *ipLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *regionLabel;
@end

@implementation SBASelectServerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (_server && _server.is_add)
    {
        return;
    }
    if (selected)
    {
        UIImage *checkImg = [UIImage imageNamed:@"checkbox_circle"];
        [_selectedView setImage:checkImg];
    }else
    {
        UIImage *uncheckImg = [UIImage imageNamed:@"checkbox_circle_un"];
        [_selectedView setImage:uncheckImg];
    }
}

- (void) setServer:(TCAddingServer*)server
{
    _server = server;
    _nameLabel.text = server.instance_id;
    NSString *ipStr = [NSString stringWithFormat:@"%@(内) %@(公)",server.inner_ip,server.public_ip];
    _ipLabel.text = ipStr;
    NSString *regionStr = [NSString stringWithFormat:@"%@@%@",server.net_type,server.region_id];
    _regionLabel.text = regionStr;
    UIImage *checkImg = [UIImage imageNamed:@"checkbox_circle"];
    if (server.is_add)
    {
        _selectedView.image = [checkImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _selectedView.tintColor = THEME_TINT_DISABLED_COLOR;
        _regionLabel.textColor = THEME_PLACEHOLDER_COLOR;
        _ipLabel.textColor = THEME_PLACEHOLDER_COLOR;
        _nameLabel.textColor = THEME_PLACEHOLDER_COLOR;
    }
}

@end
