//
//  TCServerHomeTableViewHeader.m
//  TenCloud
//
//  Created by hdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerHomeTableViewHeader.h"

@interface TCServerHomeTableViewHeader()
@property (nonatomic, weak) IBOutlet    UILabel     *titleLabel;
@property (nonatomic, weak) IBOutlet    UIView      *dotView;
@end

@implementation TCServerHomeTableViewHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_dotView.layer setCornerRadius:4];
    [_dotView setClipsToBounds:YES];
}

/*
- (void) setSectionTitle:(NSString*)title index:(NSInteger)index
{
    [_titleLabel setText:title];
    if (index % 4 == 0)
    {
        [_dotView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:68/255.0 blue:99/255.0 alpha:1.0]];
    }else if(index % 4 == 1)
    {
        [_dotView setBackgroundColor:[UIColor colorWithRed:190/255.0 green:76/255.0 blue:255/255.0 alpha:1.0]];
    }else if(index % 4 == 2)
    {
        [_dotView setBackgroundColor:[UIColor colorWithRed:40/255.0 green:172/255.0 blue:255/255.0 alpha:1.0]];
    }else
    {
        [_dotView setBackgroundColor:[UIColor colorWithRed:107/255.0 green:218/255.0 blue:9/255.0 alpha:1.0]];
    }
}
 */

@end
