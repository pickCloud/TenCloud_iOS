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


@interface TCAcceptInviteViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UILabel             *row1Label;
@property (nonatomic, weak) IBOutlet    UILabel             *row2Label;
@property (nonatomic, weak) IBOutlet    UILabel             *row3Label;
@property (nonatomic, strong)   NSString                    *code;
@property (nonatomic, strong)   TCInviteInfo                *inviteInfo;
- (void) onTapBlankArea:(id)sender;
- (IBAction) onAcceptInviteButton:(id)sender;
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
    self.title = @"完善资料";
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
        NSLog(@"info:%@",info);
        NSLog(@"info_comp:%@",info.company_name);
        NSLog(@"info_contact:%@",info.contact);
        NSLog(@"info_setting:%@",info.setting);
        weakSelf.inviteInfo = info;
        [weakSelf updateInviteInfoUI];
        [weakSelf stopLoading];
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
    NSLog(@"on tap blank area");
}

- (IBAction) onAcceptInviteButton:(id)sender
{
    NSLog(@"on accept invite button");
    NSString *phoneNum = [[TCLocalAccount shared] mobile];
    TCAcceptInviteRequest *acceptReq = [[TCAcceptInviteRequest alloc] initWithCode:_code];
    [acceptReq startWithSuccess:^(NSString *message) {
        TCInviteProfileViewController *profileVC = [[TCInviteProfileViewController alloc] initWithCode:_code joinSetting:_inviteInfo.setting shouldSetPassword:NO phoneNumber:phoneNum];;
        [self.navigationController pushViewController:profileVC animated:YES];
    } failure:^(NSString *message) {
        
    }];

}

- (void) updateInviteInfoUI
{
    if (_inviteInfo.company_name == nil ||
        _inviteInfo.company_name.length == 0 ||
        _inviteInfo.contact == nil ||
        _inviteInfo.contact.length == 0)
    {
        _row1Label.text = @"无效的邀请链接";
        _row2Label.text = @"";
        return;
    }
    
    CGRect row1Rect = _row1Label.frame;
    NSLog(@"row1Rect:%.2f, %.2f, %.2f, %.2f",row1Rect.origin.x, row1Rect.origin.y, row1Rect.size.width,
          row1Rect.size.height);
    NSMutableAttributedString *row1Str = [NSMutableAttributedString new];
    UIFont *textFont = TCFont(14.0);
    NSDictionary *greenAttr = @{NSForegroundColorAttributeName : THEME_TINT_COLOR,
                                NSFontAttributeName : textFont };
    NSDictionary *grayAttr = @{NSForegroundColorAttributeName : THEME_TEXT_COLOR,
                                NSFontAttributeName : textFont };
    NSString *str1 = [NSString stringWithFormat:@"管理员%@",_inviteInfo.contact];
    NSMutableAttributedString *tmp1 = nil;
    tmp1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:greenAttr];
    NSString *str2 = @" 邀请你加入 ";
    NSMutableAttributedString *tmp2 = nil;
    tmp2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:grayAttr];
    //[row1Str appendAttributedString:tmp1];
    CGSize boundSize = CGSizeMake(row1Rect.size.width, MAXFLOAT);
    CGRect rect1 = [str1 boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:greenAttr context:nil];
    CGRect rect2 = [str2 boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:grayAttr context:nil];
    NSString *str3 = _inviteInfo.company_name;
    NSMutableAttributedString *tmp3 = nil;
    tmp3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:greenAttr];
    CGRect rect3 = [str3 boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:greenAttr context:nil];
    CGFloat previeWidth = rect1.size.width + rect2.size.width +rect3.size.width;
    if (previeWidth <= row1Rect.size.width)
    {
        [row1Str appendAttributedString:tmp1];
        [row1Str appendAttributedString:tmp2];
        [row1Str appendAttributedString:tmp3];
        _row1Label.attributedText = row1Str;
        _row2Label.text = @"";
    }else
    {
        [row1Str appendAttributedString:tmp1];
        [row1Str appendAttributedString:tmp2];
        _row1Label.attributedText = row1Str;
        _row2Label.attributedText = tmp3;
    }
}


@end
