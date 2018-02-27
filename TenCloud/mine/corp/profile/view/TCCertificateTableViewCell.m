//
//  TCCertificateTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCertificateTableViewCell.h"
#import "TCCellData.h"

@interface TCCertificateTableViewCell()
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint      *trailingConstraint;
- (IBAction) onButton:(id)sender;
@end

@implementation TCCertificateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(TCCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    NSString *descText = data.initialValue;
    if (descText == nil || descText.length == 0)
    {
        descText = @"未认证";
    }
    self.descLabel.text = descText;//data.initialValue;
    [self.detailView setHidden:!self.data.editable];
    if (self.data.editable)
    {
        [self.detailView setHidden:NO];
        _trailingConstraint.constant = 12;
    }else
    {
        [self.detailView setHidden:YES];
        _trailingConstraint.constant = -6;
    }
}

- (IBAction) onButton:(id)sender
{
    [MBProgressHUD showError:@"暂无此功能" toView:nil];
}

@end
