//
//  TCCorpHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/22.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCCorpHomeViewController.h"
#import "TCIconTableViewCell.h"
#import "TCCustomerServiceViewController.h"
#import "TCCorpProfileViewController.h"
#import "TCPersonHomeViewController.h"
#import "TCCurrentCorp.h"
#import "TCListCorp+CoreDataClass.h"
#import "TCTemplateTableViewController.h"
//#import "TCEmptyTemplate.h"
#import "TCEmptyPermission.h"
#import "TCStaffTableViewController.h"

#import <SDWebImage/UIButton+WebCache.h>
#import "TCSettingViewController.h"
#import "TCCorpListRequest.h"
#import "TCAccountMenuViewController.h"
#import "TCSwitchAccountButton.h"
#import "TCCorp+CoreDataClass.h"
#import "TCCorpProfileRequest.h"
#import "NSString+Extension.h"


#import "TCMessageTableViewController.h"



#define PERSON_HOME_CELL_REUSE_ID       @"PERSON_HOME_CELL_REUSE_ID"

@interface TCCorpHomeViewController () <TCCurrentCorpDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UIButton        *avatarButton;
@property (nonatomic, weak) IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *contactLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *phoneLabel;
@property (nonatomic, weak) IBOutlet    UIImageView     *certificatedImageView;
@property (nonatomic, assign)   NSInteger               corpID;
@property (nonatomic, strong)   TCCorp                  *corpInfo;
@property (nonatomic, strong)   NSMutableArray          *corpArray;
@property (nonatomic, weak) IBOutlet    TCSwitchAccountButton   *switchButton;

- (IBAction) onProfilePage:(id)sender;
- (IBAction) onSwitchAccountButton:(id)sender;
- (void) onMessageButton:(id)sender;
- (void) loadCorpArray;
- (void) updateCorpInfoUI;
@end

@implementation TCCorpHomeViewController

- (id) initWithCorpID:(NSInteger)cid
{
    self = [super init];
    if (self)
    {
        _corpID = cid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self wr_setNavBarBarTintColor:THEME_TINT_COLOR];
    [self wr_setNavBarTitleColor:THEME_NAVBAR_TITLE_COLOR];
    _corpArray = [NSMutableArray new];
    [[TCCurrentCorp shared] addObserver:self];
    [self startLoading];
    __weak  __typeof(self) weakSelf = self;
    TCCorpProfileRequest *profileReq = [[TCCorpProfileRequest alloc] initWithCorpID:_corpID];
    [profileReq startWithSuccess:^(TCCorp *corp) {
        weakSelf.corpInfo = corp;
        NSLog(@"weak com:%@",weakSelf.corpInfo.name);
        [weakSelf stopLoading];
        [[TCCurrentCorp shared] setSelectedCorp:corp];
        //[[TCEmptyTemplate shared] print];
        [[TCEmptyPermission shared] print];
        [weakSelf updateCorpInfoUI];
    } failure:^(NSString *message) {
        
    }];
    
    [self loadCorpArray];
    
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
    
    _switchButton.touchedBlock = ^{
        NSLog(@"touchedddd:%@",weakSelf.corpArray);
        TCAccountMenuViewController *menuVC = [[TCAccountMenuViewController alloc] initWithCorpArray:_corpArray buttonRect:weakSelf.switchButton.frame];
        menuVC.providesPresentationContextTransitionStyle = YES;
        menuVC.definesPresentationContext = YES;
        menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        menuVC.selectBlock = ^ (TCAccountMenuViewController *vc, NSInteger selectedIndex) {
            NSLog(@"menu select %ld",selectedIndex);
            if ( selectedIndex < weakSelf.corpArray.count)
            {
                [MMProgressHUD showWithStatus:@"切换身份中"];
                TCListCorp *selectedCorp = [weakSelf.corpArray objectAtIndex:selectedIndex];
                UIViewController *homeVC = nil;
                if (selectedIndex == 0)
                {
                    homeVC = [[TCPersonHomeViewController alloc] init];
                    [[TCCurrentCorp shared] setCid:0];
                    NSString *localName = [[TCLocalAccount shared] name];
                    [[TCCurrentCorp shared] setName:localName];
                    [[TCCurrentCorp shared] save];
                }else
                {
                    homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:selectedCorp.cid];
                }
                
                NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                [newVCS removeLastObject];
                [newVCS addObject:homeVC];
                [weakSelf.navigationController setViewControllers:newVCS];
                
                [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:1.32];
                
            }
        };
        [weakSelf presentViewController:menuVC animated:NO completion:nil];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PERSON_HOME_CELL_REUSE_ID forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [cell setIcon:@"corp_home_staff" title:@"员工管理" desc:@""];
        }else if(indexPath.row == 1)
        {
            [cell setIcon:@"corp_home_template" title:@"权限模版管理" desc:@""];
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
            TCStaffTableViewController *staffVC = [TCStaffTableViewController new];
            [self.navigationController pushViewController:staffVC animated:YES];
        }else if(indexPath.row == 1)
        {
            TCTemplateTableViewController *templateVC = [TCTemplateTableViewController new];
            [self.navigationController pushViewController:templateVC animated:YES];
        }else if(indexPath.row == 2)
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
    TCCorpProfileViewController *profileVC = [[TCCorpProfileViewController alloc] initWithCorp:_corpInfo];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction) onSwitchAccountButton:(id)sender
{
    NSLog(@"on switch account ");
}

- (void) onMessageButton:(id)sender
{
    NSLog(@"on message button");
    TCMessageTableViewController *msgVC = [TCMessageTableViewController new];
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (void) loadCorpArray
{
    __weak __typeof(self) weakSelf = self;
    TCCorpListRequest *request = [TCCorpListRequest new];
    [request startWithSuccess:^(NSArray<TCCorp *> *corpArray) {
        [weakSelf.corpArray removeAllObjects];
        TCListCorp *me = [TCListCorp MR_createEntity];
        me.company_name = [[TCLocalAccount shared] name];
        me.cid = 0;
        [weakSelf.corpArray addObject:me];
        [weakSelf.corpArray addObjectsFromArray:corpArray];
    } failure:^(NSString *message) {
        
    }];
}

- (void) updateCorpInfoUI
{
    if (_corpInfo)
    {
        _nameLabel.text = [[TCCurrentCorp shared] name];
        NSString *mobile = [[TCCurrentCorp shared] mobile];
        _contactLabel.text = [[TCCurrentCorp shared] contact];
        _phoneLabel.text = [NSString hiddenPhoneNumStr:mobile];
        //NSURL *avatarURL = [NSURL URLWithString:_corpInfo.];
        UIImage *defaultAvatarImg = [UIImage imageNamed:@"default_avatar"];
        [_avatarButton setImage:defaultAvatarImg forState:UIControlStateNormal];
    }
    
}

#pragma mark - TCCurrentCorpDelegate
- (void) corpModified:(TCCurrentCorp*)corp
{
    _corpInfo.name = corp.name;
    _corpInfo.contact = corp.contact;
    _corpInfo.mobile = corp.mobile;
    _corpInfo.cid = corp.cid;
    [self updateCorpInfoUI];
}
@end
