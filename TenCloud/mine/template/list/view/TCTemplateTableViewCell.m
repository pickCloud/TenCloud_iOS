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
    
    self.bgView.layer.cornerRadius = TCSCALE(4.0);
    self.bgView.clipsToBounds = YES;
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
    
    /*
    NSString *descStr = [NSString stringWithFormat:@"功能权限 %ld 项  数据权限 %ld 项 ",funcPermNum,dataPermNum];
    _descLabel.text = descStr;
     */
    NSMutableAttributedString *desc = [NSMutableAttributedString new];
    UIFont *textFont = [UIFont systemFontOfSize:10.0];
    UIFont *digitFont = [UIFont systemFontOfSize:12.0];
    NSDictionary *textAttr = @{NSForegroundColorAttributeName : THEME_TEXT_COLOR,
                               NSFontAttributeName : textFont };
    NSDictionary *digitAttr = @{NSForegroundColorAttributeName : THEME_TINT_COLOR,
                                NSFontAttributeName : digitFont };
    NSMutableAttributedString *str1 = nil;
    str1 = [[NSMutableAttributedString alloc] initWithString:@"功能权限 " attributes:textAttr];
    NSString *tmpStr2 = [NSString stringWithFormat:@"%ld",funcPermNum];
    NSMutableAttributedString *str2 = nil;
    str2 = [[NSMutableAttributedString alloc] initWithString:tmpStr2 attributes:digitAttr];
    NSMutableAttributedString *str3 = nil;
    str3 = [[NSMutableAttributedString alloc] initWithString:@" 项  数据权限 " attributes:textAttr];
    NSString *tmpStr4 = [NSString stringWithFormat:@"%ld",dataPermNum];
    NSMutableAttributedString *str4 = nil;
    str4 = [[NSMutableAttributedString alloc] initWithString:tmpStr4 attributes:digitAttr];
    NSMutableAttributedString *str5 = nil;
    str5 = [[NSMutableAttributedString alloc] initWithString:@" 项" attributes:textAttr];
    [desc appendAttributedString:str1];
    [desc appendAttributedString:str2];
    [desc appendAttributedString:str3];
    [desc appendAttributedString:str4];
    [desc appendAttributedString:str5];
    _descLabel.attributedText = desc;
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
