//
//  TCInviteStaffViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCInviteStaffViewController.h"
#import "TCJoinSettingViewController.h"
#import "TCShareViewController.h"
#import "TCGetInviteURLRequest.h"
#import "TCJoinSettingRequest.h"
#import "YTKBatchRequest.h"

@interface TCInviteStaffViewController ()
@property (nonatomic, strong)   NSString    *inviteURLStr;
@property (nonatomic, strong)   NSMutableArray  *joinSettingArray;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UILabel     *companyNameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *keyNameLabel;
- (IBAction) onSettingButton:(id)sender;
- (IBAction) onInviteButton:(id)sender;
@end

@implementation TCInviteStaffViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"邀请员工";
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 92+27;
    }
    
    TCCurrentCorp *corp = [TCCurrentCorp shared];
    _companyNameLabel.text = corp.name;
    _joinSettingArray = [NSMutableArray new];
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    
    /*
    TCJoinSettingRequest *settingReq = [TCJoinSettingRequest new];
    [settingReq setSuccessCompletionBlock:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *settingStr = [dataDict objectForKey:@"setting"];
        NSArray *settingArray = [settingStr componentsSeparatedByString:@","];
        NSLog(@"setting:%@",settingArray);
        [weakSelf.joinSettingArray removeAllObjects];
        [weakSelf.joinSettingArray addObjectsFromArray:settingArray];
    }];
    
    TCGetInviteURLRequest *inviteURLReq = [TCGetInviteURLRequest new];
    NSMutableArray *reqArray = [NSMutableArray new];
    [reqArray addObject:settingReq];
    [reqArray addObject:inviteURLReq];
    YTKBatchRequest *batchReq = [[YTKBatchRequest alloc] initWithRequestArray:reqArray];
    [batchReq startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        [weakSelf stopLoading];
        NSLog(@"invite_url:%@",weakSelf.inviteURLStr);
        NSLog(@"join setting:%@",weakSelf.joinSettingArray);
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [MBProgressHUD showError:@"获取数据失败" toView:nil];
    }];
     */
    
    TCJoinSettingRequest *joinSettingReq = [TCJoinSettingRequest new];
    [joinSettingReq startWithSuccess:^(NSArray<NSString *> *settingArray) {
        [weakSelf stopLoading];
        [weakSelf.joinSettingArray removeAllObjects];
        [weakSelf.joinSettingArray addObjectsFromArray:settingArray];
        NSLog(@"josin settings:%@",weakSelf.joinSettingArray);
        //NSMutableString *keyStr = [NSMutableString new];
        NSMutableArray *keyArray = [NSMutableArray new];
        if ([settingArray containsObject:@"mobile"])
        {
            [keyArray addObject:@"手机号"];
        }
        if ([settingArray containsObject:@"name"])
        {
            [keyArray addObject:@"姓名"];
        }
        if ([settingArray containsObject:@"id_card"])
        {
            [keyArray addObject:@"身份证号"];
        }
        NSString *rawKeyStr = [keyArray componentsJoinedByString:@"、"];
        NSString *resKeyStr = [NSString stringWithFormat:@"%@，",rawKeyStr];
        weakSelf.keyNameLabel.text = resKeyStr;
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
    
     TCGetInviteURLRequest *inviteURLReq = [TCGetInviteURLRequest new];
     [inviteURLReq startWithSuccess:^(NSString *urlStr) {
         weakSelf.inviteURLStr = urlStr;
     } failure:^(NSString *message) {
         //[MBProgressHUD showError:message toView:nil];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) onSettingButton:(id)sender
{
    TCJoinSettingViewController *settingVC = [TCJoinSettingViewController new];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction) onInviteButton:(id)sender
{
    NSLog(@"响应邀请");
    TCShareViewController *shareVC = [[TCShareViewController alloc] init];
    shareVC.content = _inviteURLStr;
    NSLog(@"share.content:%@",shareVC.content);
    //selectVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//UIModalTransitionStyleCrossDissolve;
    shareVC.providesPresentationContextTransitionStyle = YES;
    shareVC.definesPresentationContext = YES;
    shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:shareVC animated:NO completion:nil];
}
@end
