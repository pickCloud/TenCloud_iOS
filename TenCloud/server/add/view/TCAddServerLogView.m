//
//  TCAddServerLogView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAddServerLogView.h"
#import "UIView+TCAlertView.h"

@interface TCAddServerLogView()
@property (nonatomic, weak) IBOutlet    UITextView  *logTextView;
- (IBAction) onHideButton:(id)sender;
@end

@implementation TCAddServerLogView

- (id) init
{
    self = [super init];
    if(self)
    {
        _logTextView.textColor = THEME_PLACEHOLDER_COLOR;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        _logTextView.textColor = THEME_PLACEHOLDER_COLOR;
    }
    return self;
}

- (void) setText:(NSString*)text
{
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.logTextView.text = text;
    });
}

- (void) setAttrText:(NSAttributedString*)text
{
    _logTextView.attributedText = text;
}

- (IBAction) onHideButton:(id)sender
{
    [self hideView];
}


@end
