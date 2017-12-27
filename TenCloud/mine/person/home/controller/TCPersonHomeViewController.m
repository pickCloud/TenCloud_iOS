//
//  TCPersonHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/22.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPersonHomeViewController.h"
#import "TCIconTableViewCell.h"
#import "TCCustomerServiceViewController.h"
#import "TCPersonProfileViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "TCSettingViewController.h"

//tmp use
#import "TCLoginViewController.h"


#define PERSON_HOME_CELL_REUSE_ID       @"PERSON_HOME_CELL_REUSE_ID"

@interface TCPersonHomeViewController ()<TCLocalAccountDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UIButton        *avatarButton;
@property (nonatomic, weak) IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *phoneLabel;
@property (nonatomic, weak) IBOutlet    UIImageView     *certificatedImageView;
- (IBAction) onProfilePage:(id)sender;
- (void) onMessageButton:(id)sender;
@end

@implementation TCPersonHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [[TCLocalAccount shared] addObserver:self];
    
    UIImage *messageIconImg = [UIImage imageNamed:@"nav_message"];
    UIButton *msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgButton setImage:messageIconImg forState:UIControlStateNormal];
    [msgButton sizeToFit];
    [msgButton addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:msgButton];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCIconTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:PERSON_HOME_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    
    [self updateAccountInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[TCLocalAccount shared] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PERSON_HOME_CELL_REUSE_ID forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [cell setIcon:@"person_home_corp" title:@"我的公司" desc:@"2家公司"];
        }else
        {
            [cell setIcon:@"person_home_service" title:@"客户服务" desc:@""];
        }
    }else if(indexPath.section == 1)
    {
        [cell setIcon:@"person_home_setting" title:@"设置" desc:@""];
    }
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            
        }else if(indexPath.row == 1)
        {
            TCCustomerServiceViewController *serviceVC = [TCCustomerServiceViewController new];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
    }else if(indexPath.section == 1)
    {
        TCSettingViewController *settingVC = [TCSettingViewController new];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

#pragma mark - extension
- (IBAction) onProfilePage:(id)sender
{
    TCPersonProfileViewController *profileVC = [TCPersonProfileViewController new];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void) onMessageButton:(id)sender
{
    NSLog(@"on message button");
    [[TCLocalAccount shared] logout];
    TCLoginViewController *loginVC = [TCLoginViewController new];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginNav];
}

- (void) updateAccountInfo
{
    NSString *name = [[TCLocalAccount shared] name];
    _nameLabel.text = name;
    TCLocalAccount *account = [TCLocalAccount shared];
    NSString *rawPhoneStr = account.mobile;
    NSString *filteredPhone = rawPhoneStr;
    if (rawPhoneStr.length >= 11)
    {
        NSRange replaceRange = NSMakeRange(3, 4);
        filteredPhone = [rawPhoneStr stringByReplacingCharactersInRange:replaceRange withString:@"****"];
    }
    _phoneLabel.text = filteredPhone;
    NSURL *avatarURL = [NSURL URLWithString:account.avatar];
    UIImage *defaultAvatarImg = [UIImage imageNamed:@"default_avatar"];
    [_avatarButton sd_setImageWithURL:avatarURL forState:UIControlStateNormal placeholderImage:defaultAvatarImg];
}

#pragma mark - Account Delegate
- (void) accountLoggedIn:(TCLocalAccount*)account
{
    [self updateAccountInfo];
}

- (void) accountLogout:(TCLocalAccount*)account
{
    [self updateAccountInfo];
}

- (void) accountModified:(TCLocalAccount*)account
{
    [self updateAccountInfo];
}
@end
