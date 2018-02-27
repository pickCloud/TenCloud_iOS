//
//  TCInviteLoginViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/14.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAcceptInviteViewController.h"
#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
#import "TCInviteInfoRequest.h"
#import "TCInviteInfo+CoreDataClass.h"
#import "TCAcceptInviteRequest.h"
#import "TCInviteProfileViewController.h"
#import "TCStaffStatusRequest.h"
#import "TCInviteJoinedViewController.h"
#import "TCPageManager.h"


@interface TCAcceptInviteViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UILabel             *row1Label;
@property (nonatomic, weak) IBOutlet    UILabel             *row2Label;
@property (nonatomic, weak) IBOutlet    UILabel             *row3Label;
@property (nonatomic, weak) IBOutlet    UIButton            *inviteButton;
@property (nonatomic, strong)   NSString                    *code;
@property (nonatomic, strong)   TCInviteInfo                *inviteInfo;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAcceptInviteButton:(id)sender;
- (IBAction) onEnterSystem:(id)sender;
- (void) updateInviteInfoUI;
@end

@implementation TCAcceptInviteViewController

- (instancetype) initWithCode:(NSString *)code
{
    self = [super init];
    if (self)
    {
        _code = code;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请加入";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    _row3Label.font = TCFont(14);
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+25;
    }
    
    
    UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(onTapBlankArea:)];
    [tapGesture setDelegate:self];
    [self.view addGestureRecognizer:tapGesture];
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCInviteInfoRequest *req = [[TCInviteInfoRequest alloc] initWithCode:_code];
    [req startWithSuccess:^(TCInviteInfo *info) {
        weakSelf.inviteInfo = info;
        [weakSelf updateInviteInfoUI];
        
        TCStaffStatusRequest *statusReq = [[TCStaffStatusRequest alloc] initWithCorpID:info.cid];
        [statusReq startWithSuccess:^(NSInteger status) {
            if (status == STAFF_STATUS_PENDING ||
                status == STAFF_STATUS_PASS)
            {
                TCInviteJoinedViewController *joinedVC = [[TCInviteJoinedViewController alloc] initWithStaffStatus:status corpID:info.cid];
                NSMutableArray *newVCS = [NSMutableArray array];
                [newVCS addObject:joinedVC];
                [weakSelf.navigationController setViewControllers:newVCS];
            }else
            {
                [weakSelf stopLoading];
            }
        } failure:^(NSString *message) {
            [weakSelf stopLoading];
            [MBProgressHUD showError:message toView:nil];
        }];
    } failure:^(NSString *message) {
        NSLog(@"info_msg:%@",message);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (void) onTapBlankArea:(id)sender
{
    
}

- (IBAction) onAcceptInviteButton:(id)sender
{
    if ([self isInviteInfoInvalid])
    {
        [self onEnterSystem:nil];
        return;
    }
    NSString *phoneNum = [[TCLocalAccount shared] mobile];
    TCAcceptInviteRequest *acceptReq = [[TCAcceptInviteRequest alloc] initWithCode:_code];
    [acceptReq startWithSuccess:^(NSString *message) {
        TCInviteProfileViewController *profileVC = [[TCInviteProfileViewController alloc] initWithCode:_code joinSetting:_inviteInfo.setting shouldSetPassword:NO phoneNumber:phoneNum];
        [TCPageManager replaceViewController:self withViewController:profileVC];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (IBAction) onEnterSystem:(id)sender
{
    [TCPageManager enterHomePage];
}

- (BOOL) isInviteInfoInvalid
{
    BOOL isValid = _inviteInfo.company_name == nil ||
    _inviteInfo.company_name.length == 0 ||
    _inviteInfo.contact == nil ||
    _inviteInfo.contact.length == 0;
    return isValid;
}

- (void) updateInviteInfoUI
{
    if ([self isInviteInfoInvalid])
    {
        _row1Label.text = @"邀请链接已过期，请联系管理员重新邀请";
        _row2Label.text = @"";
        [_inviteButton setTitle:@"进入系统" forState:UIControlStateNormal];
        return;
    }
    
    NSMutableAttributedString *row1Str = [NSMutableAttributedString new];
    UIFont *textFont = TCFont(14.0);
    NSDictionary *greenAttr = @{NSForegroundColorAttributeName : THEME_TINT_COLOR,
                                NSFontAttributeName : textFont };
    NSDictionary *grayAttr = @{NSForegroundColorAttributeName : THEME_TEXT_COLOR,
                                NSFontAttributeName : textFont };
    NSString *str1 = [NSString stringWithFormat:@"%@",_inviteInfo.contact];
    NSMutableAttributedString *tmp1 = nil;
    tmp1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:greenAttr];
    NSString *str2 = @" 邀请你加入企业 ";
    NSMutableAttributedString *tmp2 = nil;
    tmp2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:grayAttr];
    
    NSString *str3 = _inviteInfo.company_name;
    NSMutableAttributedString *tmp3 = nil;
    tmp3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:greenAttr];
    
    [row1Str appendAttributedString:tmp3];
    [row1Str appendAttributedString:tmp2];
    _row1Label.attributedText = row1Str;
    _row2Label.text = @"";
}


@end
