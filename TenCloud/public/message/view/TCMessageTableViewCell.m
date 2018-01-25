//
//  TCMessageTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2018/1/17.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCMessageTableViewCell.h"
#import "TCMessage+CoreDataClass.h"

@interface TCMessageTableViewCell()
@property (nonatomic, strong)   TCMessage           *message;
@property (nonatomic, weak) IBOutlet    UILabel     *operationLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *contentLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *actionButton;
@property (nonatomic, weak) IBOutlet    UIButton    *disclosureButton;
- (IBAction) onActionButton:(id)sender;
@end

@implementation TCMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.05];
    self.selectedBackgroundView = selectedBgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMessage:(TCMessage*)message
{
    _message = message;
    NSString *operation = nil;
    if (message.mode == 1)
    {
        operation = @"加入企业";
    }else if(message.mode == 2)
    {
        operation = @"企业变更";
    }else if(message.mode == 3)
    {
        operation = @"离开企业";
    }else if(message.mode == 4)
    {
        operation = @"添加主机";
    }else if(message.mode == 5)
    {
        operation = @"构建镜像";
    }
    NSString *operationStr = [NSString stringWithFormat:@"%@ %@",operation,message.update_time];
    _operationLabel.text = operationStr;
    _contentLabel.text = message.content;
    if (message.mode == 3 && message.sub_mode == 0)
    {
        _actionButton.hidden = YES;
        _disclosureButton.hidden = YES;
    }else
    {
        _actionButton.hidden = NO;
        _disclosureButton.hidden = NO;
    }
    if (message.sub_mode == 0)
    {
        [_actionButton setTitle:@"马上审核" forState:UIControlStateNormal];
    }else if(message.sub_mode == 1)
    {
        [_actionButton setTitle:@"重新提交" forState:UIControlStateNormal];
    }else if(message.sub_mode == 2)
    {
        [_actionButton setTitle:@"进入企业" forState:UIControlStateNormal];
    }else if(message.sub_mode == 3)
    {
        [_actionButton setTitle:@"马上查看" forState:UIControlStateNormal];
    }else if(message.sub_mode == 4)
    {
        [_actionButton setTitle:@"查看项目" forState:UIControlStateNormal];
    }
    
    NSMutableAttributedString *resultStr = [NSMutableAttributedString new];
    NSString *rawContent = message.content;
    NSInteger totalLength = rawContent.length;
    NSInteger offset = 0;
    UIFont *textFont = TCFont(13.0);
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName : THEME_TEXT_COLOR,
                               NSFontAttributeName : textFont };
    NSDictionary *lightAttr = @{NSForegroundColorAttributeName : THEME_TINT_COLOR,
                                NSFontAttributeName : textFont };
    BOOL hasNext = NO;
    do{
        NSRange searchRange = NSMakeRange(offset, totalLength - offset);
        NSRange startRange = [rawContent rangeOfString:@"【" options:NSCaseInsensitiveSearch range:searchRange];
        if (startRange.length > 0 && startRange.location == offset)
        {
            NSRange endRange = [rawContent rangeOfString:@"】" options:NSCaseInsensitiveSearch range:searchRange];
            NSRange wordRange = NSMakeRange(startRange.location, endRange.location - startRange.location + endRange.length);
            NSString *tmpWord = [rawContent substringWithRange:wordRange];
            tmpWord = [tmpWord stringByReplacingOccurrencesOfString:@"【" withString:@""];
            tmpWord = [tmpWord stringByReplacingOccurrencesOfString:@"】" withString:@""];
            tmpWord = [NSString stringWithFormat:@"%@ ",tmpWord];
            NSMutableAttributedString *word = nil;
            word = [[NSMutableAttributedString alloc] initWithString:tmpWord attributes:lightAttr];
            [resultStr appendAttributedString:word];
            offset += wordRange.length;
        }else if(startRange.length > 0)
        {
            NSRange wordRange = NSMakeRange(offset, startRange.location - offset);
            NSString *tmpWord = [rawContent substringWithRange:wordRange];
            tmpWord = [NSString stringWithFormat:@"%@ ",tmpWord];
            NSMutableAttributedString *word = nil;
            word = [[NSMutableAttributedString alloc] initWithString:tmpWord attributes:normalAttr];
            [resultStr appendAttributedString:word];
            offset += wordRange.length;
        }else
        {
            NSRange wordRange = NSMakeRange(offset, totalLength - offset);
            NSString *tmpWord = [rawContent substringWithRange:wordRange];
            tmpWord = [NSString stringWithFormat:@"%@ ",tmpWord];
            NSMutableAttributedString *word = nil;
            word = [[NSMutableAttributedString alloc] initWithString:tmpWord attributes:normalAttr];
            [resultStr appendAttributedString:word];
            offset += wordRange.length;
        }
        hasNext = (offset < totalLength);
    }while (hasNext);
    _contentLabel.attributedText = resultStr;
}

- (IBAction) onActionButton:(id)sender
{
    NSLog(@" on action buttton");
    if (_actionBlock)
    {
        _actionBlock(self,_message);
    }
    
}
@end
