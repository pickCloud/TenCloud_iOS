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
#import "TCCorpHomeViewController.h"
#import "TCListCorp+CoreDataClass.h"
#import "TCCurrentCorp.h"
#import "UIView+MGBadgeView.h"
#import "TCMessageManager.h"
//#import "TCMessageViewController.h"
#import "TCMessageTableViewController.h"

#import "TCPersonProfileViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "TCSettingViewController.h"
#import "TCMyCorpTableViewController.h"
#import "TCCorpListRequest.h"
#import "TCAccountMenuViewController.h"
#import "TCSwitchAccountButton.h"
#import "TCCorp+CoreDataClass.h"


#define PERSON_HOME_CELL_REUSE_ID       @"PERSON_HOME_CELL_REUSE_ID"

@interface TCPersonHomeViewController ()<TCLocalAccountDelegate,TCMessageManagerDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UIButton        *avatarButton;
@property (nonatomic, weak) IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *phoneLabel;
@property (nonatomic, weak) IBOutlet    UIImageView     *certificatedImageView;
@property (nonatomic, strong)   NSMutableArray          *corpArray;
@property (nonatomic, strong)   NSMutableArray          *passedCorpArray;
@property (nonatomic, strong)   UIButton                *messageButton;
@property (nonatomic, weak) IBOutlet    TCSwitchAccountButton   *switchButton;

- (IBAction) onProfilePage:(id)sender;
- (IBAction) onSwitchAccountButton:(id)sender;
- (void) onMessageButton:(id)sender;
- (void) loadCorpArray;
@end

@implementation TCPersonHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    [self wr_setNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
    [[TCLocalAccount shared] addObserver:self];
    _corpArray = [NSMutableArray new];
    _passedCorpArray = [NSMutableArray new];
    [self startLoading];
    [self loadCorpArray];
    
    UIImage *messageIconImg = [UIImage imageNamed:@"nav_message"];
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_messageButton setImage:messageIconImg forState:UIControlStateNormal];
    [_messageButton sizeToFit];
    [_messageButton addTarget:self action:@selector(onMessageButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSInteger msgCount = [[TCMessageManager shared] count];
    [_messageButton.badgeView setBadgeValue:msgCount];
    [_messageButton.badgeView setOutlineWidth:0.0];
    [_messageButton.badgeView setBadgeColor:[UIColor redColor]];
    [_messageButton.badgeView setMinDiameter:6.0];
    [_messageButton.badgeView setPosition:MGBadgePositionTopRight];
    
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:_messageButton];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCIconTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:PERSON_HOME_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    
    __weak __typeof(self) weakSelf = self;
    _switchButton.touchedBlock = ^{
        //NSMutableArray *passedCorpArray = [NSMutableArray new];
        [weakSelf.passedCorpArray removeAllObjects];
        for (TCListCorp * tmpCorp in weakSelf.corpArray)
        {
            if (tmpCorp.status == 3 || tmpCorp.status == 4 || tmpCorp.cid == 0)
            {
                [weakSelf.passedCorpArray addObject:tmpCorp];
            }
        }
        TCAccountMenuViewController *menuVC = [[TCAccountMenuViewController alloc] initWithCorpArray:weakSelf.passedCorpArray buttonRect:weakSelf.switchButton.frame];
        menuVC.providesPresentationContextTransitionStyle = YES;
        menuVC.definesPresentationContext = YES;
        menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        menuVC.selectBlock = ^ (TCAccountMenuViewController *vc, NSInteger selectedIndex) {
            NSLog(@"menu select %ld",selectedIndex);
            //NSInteger corpIndex = selectedIndex - 1;
            if ( selectedIndex < weakSelf.corpArray.count)
            {
                [MMProgressHUD showWithStatus:@"切换身份中"];
                TCListCorp *selectedCorp = [weakSelf.passedCorpArray objectAtIndex:selectedIndex];
                TCCorpHomeViewController *corpHome = [[TCCorpHomeViewController alloc] initWithCorpID:selectedCorp.cid];
                
                NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                [newVCS removeLastObject];
                [newVCS addObject:corpHome];
                [weakSelf.navigationController setViewControllers:newVCS];
                
                [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:1.32];
                
            }
        };
        [weakSelf presentViewController:menuVC animated:NO completion:nil];
    };
    
    [self updateAccountInfo];
    [[TCMessageManager shared] addObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[TCLocalAccount shared] removeObserver:self];
    [[TCMessageManager shared] removeObserver:self];
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
            NSString *corpDesc = nil;
            if (_corpArray.count <= 0)
            {
                corpDesc = @"";
            }else
            {
                corpDesc = [NSString stringWithFormat:@"%ld家公司",_corpArray.count - 1];
            }
            [cell setIcon:@"person_home_corp" title:@"我的公司" desc:corpDesc];
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
            TCMyCorpTableViewController *corpVC = [TCMyCorpTableViewController new];
            [self.navigationController pushViewController:corpVC animated:YES];
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

- (IBAction) onSwitchAccountButton:(id)sender
{
    NSLog(@"on switch account ");
}

- (void) onMessageButton:(id)sender
{
    NSLog(@"on message button");
    //TCMessageViewController *msgVC = [TCMessageViewController new];
    TCMessageTableViewController *msgVC = [TCMessageTableViewController new];
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (void) loadCorpArray
{
    __weak __typeof(self) weakSelf = self;
    TCCorpListRequest *request = [[TCCorpListRequest alloc] initWithStatus:7];
    [request startWithSuccess:^(NSArray<TCListCorp *> *corpArray) {
        [weakSelf.corpArray removeAllObjects];
        TCCorp *me = [TCCorp MR_createEntity];
        me.company_name = [[TCLocalAccount shared] name];
        [weakSelf.corpArray addObject:me];
        [weakSelf.corpArray addObjectsFromArray:corpArray];
        [weakSelf stopLoading];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (void) updateAccountInfo
{
    NSString *name = [[TCLocalAccount shared] name];
    _nameLabel.text = name;
    TCLocalAccount *account = [TCLocalAccount shared];
    _phoneLabel.text = account.hiddenMobile;
    NSURL *avatarURL = [NSURL URLWithString:account.avatar];
    UIImage *defaultAvatarImg = [UIImage imageNamed:@"default_avatar"];
    [_avatarButton sd_setImageWithURL:avatarURL forState:UIControlStateNormal placeholderImage:defaultAvatarImg];
    
    if (_corpArray.count > 0)
    {
        TCCorp *firstCorp = _corpArray.firstObject;
        [firstCorp setName:[[TCLocalAccount shared] name]];
        [firstCorp setCompany_name:[[TCLocalAccount shared] name]];
    }
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

#pragma mark - TCMessageManagerDelegate
- (void) messageCountChanged:(NSInteger)count
{
    NSLog(@"se msg btn badge:%ld",count);
    _messageButton.badgeView.badgeValue = count;
}
@end
