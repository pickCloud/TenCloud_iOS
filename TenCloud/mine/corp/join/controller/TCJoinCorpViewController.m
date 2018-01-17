//
//  TCJoinCorpViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCJoinCorpViewController.h"
#import "TCJoinSettingViewController.h"
//#import "TCShareViewController.h"
//#import "TCGetInviteURLRequest.h"
//#import "TCJoinSettingRequest.h"
#import "YTKBatchRequest.h"

@interface TCJoinCorpViewController ()
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
//@property (nonatomic, weak) IBOutlet    UILabel     *companyNameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *keyNameLabel;
- (IBAction) onSettingButton:(id)sender;
@end

@implementation TCJoinCorpViewController

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
    self.title = @"加入已有企业";
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 92+27;
    }
    
    //TCCurrentCorp *corp = [TCCurrentCorp shared];
    //_companyNameLabel.text = corp.name;
    
}

- (void) dealloc
{
    
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

@end
