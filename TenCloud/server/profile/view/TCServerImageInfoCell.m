//
//  TCServerImageInfoCell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerImageInfoCell.h"
#import "TCImageInfo+CoreDataClass.h"

@interface TCServerImageInfoCell()
@property (nonatomic, weak) IBOutlet    UILabel     *numLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *versionLabel;
@end

@implementation TCServerImageInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setImageInfo:(TCImageInfo*)info withNumber:(NSInteger)number
{
    NSString *numStr = nil;
    if (number > 0)
    {
        numStr = [NSString stringWithFormat:@"镜像%ld",number];
    }else
    {
        numStr = @"镜像";
    }
    _numLabel.text = numStr;
    _nameLabel.text = info.image_name;
    NSString *verStr = info.image_version;
    if (verStr == nil || verStr.length == 0)
    {
        verStr = @"无";
    }
    _versionLabel.text = verStr;
    //_nameLabel.text = info.system_disk_type;
    //_sizeLabel.text = info.system_disk_size;//@"20G";
}
@end
