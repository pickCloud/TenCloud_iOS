//
//  TCInviteSuccessViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCInviteSuccessViewController.h"
#import "TCTabBarController.h"

@interface TCInviteSuccessViewController ()
@property (nonatomic, strong)   NSString    *titleText;
@property (nonatomic, strong)   NSString    *descText;
@property (nonatomic, weak) IBOutlet    UILabel     *titleLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *descLabel;
@property (nonatomic, weak) IBOutlet    UIButton    *button;
- (IBAction) onButton:(id)sender;
- (IBAction) onMyCorpButton:(id)sender;
@end

@implementation TCInviteSuccessViewController

- (id) initWithTitle:(NSString *)title desc:(NSString*)desc
{
    self = [super init];
    if (self)
    {
        _titleText = title;
        _descText = desc;
        _finishBlock = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"完善资料";
    _titleLabel.text = _titleText;
    _descLabel.text = _descText;
    if (_buttonTitle && _buttonTitle.length > 0)
    {
        [_button setTitle:_buttonTitle forState:UIControlStateNormal];
    }else
    {
        [_button setTitle:@"好的" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) onButton:(id)sender
{
    if (_finishBlock)
    {
        _finishBlock(self);
    }
    TCTabBarController *tabBarController = [TCTabBarController new];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
}

- (IBAction) onMyCorpButton:(id)sender
{
    NSLog(@"on my corp ");
    TCTabBarController *tabBarController = [TCTabBarController new];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
    [tabBarController setSelectedIndex:4];
}

@end