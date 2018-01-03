//
//  TCTemplateTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCTemplateTableViewCell.h"
#import "TCTemplate+CoreDataClass.h"

@interface TCTemplateTableViewCell()
@property (nonatomic, weak) IBOutlet    UIView          *bgView;
@property (nonatomic, weak) IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *descLabel;

- (void) updateUI;
@end

@implementation TCTemplateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bgView.layer.cornerRadius = TCSCALE(2.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateUI];
}

- (void) setTemplate:(TCTemplate*)tmpl
{
    _nameLabel.text = tmpl.name;
    NSInteger funcPermNum = 0;
    NSInteger dataPermNum = 0;
    NSString *permissionStr = tmpl.permissions;
    if (permissionStr && permissionStr.length > 0)
    {
        NSArray *permissionIDArray = [permissionStr componentsSeparatedByString:@","];
        if (permissionIDArray)
        {
            funcPermNum = permissionIDArray.count;
        }
    }
    NSString *projPermissionStr = tmpl.access_projects;
    if (projPermissionStr && projPermissionStr.length > 0)
    {
        NSArray *projPermissionIDArray = [projPermissionStr componentsSeparatedByString:@","];
        if (projPermissionIDArray)
        {
            dataPermNum += projPermissionIDArray.count;
        }
    }
    NSString *serverPermissionStr = tmpl.access_servers;
    if (serverPermissionStr && serverPermissionStr.length > 0)
    {
        NSArray *serverPermissionIDArray = [serverPermissionStr componentsSeparatedByString:@","];
        if (serverPermissionIDArray)
        {
            dataPermNum += serverPermissionIDArray.count;
        }
    }
    NSString *filePermissionStr = tmpl.access_filehub;
    if (filePermissionStr && filePermissionStr.length > 0)
    {
        NSArray *filePermissionIDArray = [filePermissionStr componentsSeparatedByString:@","];
        if (filePermissionIDArray)
        {
            dataPermNum += filePermissionIDArray.count;
        }
    }
    
    NSString *descStr = [NSString stringWithFormat:@"功能权限 %ld 项  数据权限 %ld 项 ",funcPermNum,dataPermNum];
    _descLabel.text = descStr;
}

- (void) updateUI
{
    if (self.highlighted)
    {
        self.bgView.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
    }else
    {
        self.bgView.backgroundColor = TABLE_CELL_BG_COLOR;
    }
}
@end
