//
//  TCAppProfileSection3Header.m
//  TenCloud
//
//  Created by huangdx on 2018/3/27.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAppProfileSection3Header.h"

@interface TCAppProfileSection3Header()
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
- (IBAction) onDetailButton:(id)sender;
@end

@implementation TCAppProfileSection3Header

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) onDetailButton:(id)sender
{
    NSLog(@"on detail button");
}

- (void) setSectionTitle:(NSString*)title
{
    _nameLabel.text = title;
}
@end
