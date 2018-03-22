//
//  TCServerDiskInfoCell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/22.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerDiskInfoCell.h"
#import "TCDiskInfo+CoreDataClass.h"

@interface TCServerDiskInfoCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *typeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *sizeLabel;
@end

@implementation TCServerDiskInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDiskInfo:(TCDiskInfo*)info withNumber:(NSInteger)number
{
    NSString *nameStr = nil;
    if (number > 0)
    {
        nameStr = [NSString stringWithFormat:@"存储%ld",number];
    }else
    {
        nameStr = @"存储";
    }
    _nameLabel.text = nameStr;
    _typeLabel.text = info.system_disk_type;
    _sizeLabel.text = info.system_disk_size;//@"20G";
}
@end
