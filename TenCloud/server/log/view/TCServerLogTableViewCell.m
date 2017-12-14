//
//  TCServerLogTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/12.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerLogTableViewCell.h"
#import "TCServerLog+CoreDataClass.h"

@interface TCServerLogTableViewCell()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *operationLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *timeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *resultLabel;
@end

@implementation TCServerLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
    self.selectedBackgroundView = selectedBgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setLog:(TCServerLog*)log
{
    _nameLabel.text = log.user;
    if (log.user.length == 0)
    {
        _nameLabel.text = @" ";
    }
    _timeLabel.text = log.created_time;
    NSString *operationStr = nil;
    if (log.operation == ServerLogOperationPowerOn)
    {
        operationStr = @"开机";
    }else if(log.operation == ServerLogOperationRestart)
    {
        operationStr = @"重启";
    }else if(log.operation == ServerLogOperationPowerOff)
    {
        operationStr = @"关机";
    }else
    {
        operationStr = @"未知操作";
    }
    _operationLabel.text = operationStr;
    NSString *resultStr = nil;
    if (log.operation_status == ServerLogOperationStatusSuccess)
    {
        resultStr = @"成功";
    }else if(log.operation_status == ServerLogOperationStatusFail)
    {
        resultStr = @"失败";
    }else
    {
        resultStr = @"未知结果";
    }
    _resultLabel.text = resultStr;
}

@end
