//
//  TCInviteJoinedViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCInviteJoinedViewController.h"
#import "TCTabBarController.h"
#import "TCMyCorpTableViewController.h"
#import "TCPersonHomeViewController.h"
#import "TCPageManager.h"


@interface TCInviteJoinedViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign)   NSInteger       staffStatus;
@property (nonatomic, assign)   NSInteger       corpID;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UILabel             *row1Label;
@property (nonatomic, weak) IBOutlet    UIView              *myCorpPanel;
- (IBAction) onEnterSystemButton:(id)sender;
- (IBAction) onMyCorpButton:(id)sender;
@end

@implementation TCInviteJoinedViewController

- (instancetype) initWithStaffStatus:(NSInteger)status corpID:(NSInteger)corpID
{
    self = [super init];
    if (self)
    {
        _staffStatus = status;
        _corpID = corpID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请加入";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+25;
    }
    
    if (_staffStatus == STAFF_STATUS_PASS)
    {
        _row1Label.text = @"你已经加入了该企业，请勿重复提交。";
        _myCorpPanel.hidden = YES;
    }else
    {
        _row1Label.text = @"你已经提交申请，请等待管理员审核。";
        _myCorpPanel.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (IBAction) onEnterSystemButton:(id)sender
{
    [TCPageManager enterHomePage];
    //TCTabBarController *tabBarController = [TCTabBarController new];
    //[[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
}

- (IBAction) onMyCorpButton:(id)sender
{
    TCTabBarController *tabBarController = [TCTabBarController new];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
    [tabBarController setSelectedIndex:4];
    
    UINavigationController *mineNav = [[tabBarController viewControllers] objectAtIndex:4];
    TCMyCorpTableViewController *myCorpVC = [TCMyCorpTableViewController new];
    TCPersonHomeViewController *personVC = [[TCPersonHomeViewController alloc] init];
    [[TCCurrentCorp shared] setCid:0];
    NSString *localName = [[TCLocalAccount shared] name];
    [[TCCurrentCorp shared] setName:localName];
    [[TCCurrentCorp shared] save];
    NSArray *viewControllers = mineNav.viewControllers;
    NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
    [newVCS removeLastObject];
    [newVCS addObject:personVC];
    [newVCS addObject:myCorpVC];
    [mineNav setViewControllers:newVCS];
}

@end
