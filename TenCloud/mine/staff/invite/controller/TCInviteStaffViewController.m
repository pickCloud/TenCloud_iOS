//
//  TCInviteStaffViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCInviteStaffViewController.h"
#import "TCJoinSettingViewController.h"

@interface TCInviteStaffViewController ()
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UILabel     *companyNameLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *keyNameLabel;
- (IBAction) onSettingButton:(id)sender;
- (IBAction) onInviteButton:(id)sender;
@end

@implementation TCInviteStaffViewController

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
}
@end
