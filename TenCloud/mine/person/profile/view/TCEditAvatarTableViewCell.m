//
//  TCEditAvatarTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditAvatarTableViewCell.h"
#import "TCEditCellData.h"

@interface TCEditAvatarTableViewCell()
@property (nonatomic, weak) IBOutlet    UIImageView     *avatarView;
- (IBAction) onButton:(id)sender;
@end

@implementation TCEditAvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(TCEditCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    self.descLabel.text = data.initialValue;
}

- (IBAction) onButton:(id)sender
{
    NSLog(@"avatar button");
    
}

@end
