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
//@property (nonatomic, strong)       TCShowAlertView *alertView;
@property (nonatomic, weak) IBOutlet    UITextView  *logTextView;
- (IBAction) onHideButton:(id)sender;
@end

@implementation TCAddServerLogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/*
- (instancetype) createView
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TCAddServerLogView"
                                                   owner:self options:nil];
    if (views.count > 0)
    {
        UIView *logView = views.firstObject;
        _alertView = [TCShowAlertView alertViewWithView:logView];
        _alertView.backgoundTapDismissEnable = YES;
        //_logAlertView = [TCShowAlertView alertViewWithView:logView];
        //_logAlertView.backgoundTapDismissEnable = YES;
        //[_logAlertView show];
        _logTextView.text = @"哈哈哈";
        NSLog(@"logTextView1:%@",_logTextView);
    }
    return self;
}
 */

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
    NSLog(@"sssstext:%@",text);
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.logTextView.text = text;
        NSLog(@"logTextView2:%@",weakSelf.logTextView);
        NSLog(@"weal log text:%@",weakSelf.logTextView.text);
    });
    //_logTextView.text = text;
}

- (void) setAttrText:(NSAttributedString*)text
{
    _logTextView.attributedText = text;
}
/*
- (void) show
{
    if (_alertView)
    {
        [_alertView show];
    }
}
 */

- (IBAction) onHideButton:(id)sender
{
    [self hideView];
}


@end
