//
//  TCMessageTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/16.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCMessageTableViewController.h"
#import "TCSearchMessageRequest.h"
#import "TCMessageTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TCMessage+CoreDataClass.h"
#import "TCCorpHomeViewController.h"
#import "TCMessageListRequest.h"
#import "TCCorpProfileRequest.h"
#import "TCStaffTableViewController.h"
#import "TCTextRefreshAutoFooter.h"
#import "MKDropdownMenu.h"
#import "ShapeSelectView.h"
#import "TCCorp+CoreDataClass.h"
#import "TCMessageManager.h"
#import "TCInviteInfoRequest.h"
#import "TCAcceptInviteRequest.h"
#import "TCInviteProfileViewController.h"
#import "TCInviteInfo+CoreDataClass.h"
#import "TCServerListViewController.h"
#import "TCAddServerViewController.h"
#import "TCPageManager.h"

#define MESSAGE_CELL_ID             @"MESSAGE_CELL_ID"

@interface TCMessageTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,
MKDropdownMenuDelegate,MKDropdownMenuDataSource>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    MKDropdownMenu  *modeMenu;
@property (nonatomic, weak) IBOutlet    UITextField     *keywordField;
@property (nonatomic, weak) IBOutlet    UIView          *keyboardPanel;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, strong)   NSMutableArray          *modeMenuOptions;
@property (nonatomic, assign)   NSInteger               modeSelectedIndex;
@property (nonatomic, strong)   NSMutableArray          *messageArray;
@property (nonatomic, assign)   NSInteger               pageIndex;
- (void) doSearchWithKeyword:(NSString*)keyword mode:(NSInteger)mode;
- (void) onShowKeyboard:(NSNotification*)notification;
- (void) onHideKeyboard:(NSNotification*)notification;
- (void) reloadMessages;
- (void) loadMoreMessages;
- (IBAction) onCloseKeyboard:(id)sender;
@end

@implementation TCMessageTableViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        _pageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息盒子";
    _messageArray = [NSMutableArray new];
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"TCMessageTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:MESSAGE_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    
    [self startLoading];
    [self reloadMessages];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(onShowKeyboard:)
                       name:UIKeyboardWillShowNotification object:nil];
    [notiCenter addObserver:self selector:@selector(onHideKeyboard:)
                       name:UIKeyboardWillHideNotification object:nil];
    
    TCTextRefreshAutoFooter *footer = [TCTextRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessages)];
    footer.automaticallyRefresh = YES;
    footer.automaticallyHidden = YES;
    self.tableView.mj_footer = footer;
    
    _modeMenuOptions = [NSMutableArray new];
    [_modeMenuOptions addObject:@"全部"];
    [_modeMenuOptions addObject:@"加入企业"];
    [_modeMenuOptions addObject:@"企业变更"];
    [_modeMenuOptions addObject:@"离开企业"];
    [_modeMenuOptions addObject:@"添加主机"];
    [_modeMenuOptions addObject:@"构建镜像"];
    
    UIColor *dropDownBgColor = [UIColor colorWithRed:39/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    self.modeMenu.selectedComponentBackgroundColor = dropDownBgColor;
    self.modeMenu.dropdownBackgroundColor = dropDownBgColor;
    self.modeMenu.dropdownShowsTopRowSeparator = YES;
    self.modeMenu.dropdownShowsBottomRowSeparator = NO;
    self.modeMenu.dropdownShowsBorder = NO;
    self.modeMenu.backgroundDimmingOpacity = 0.5;//0.05;
    self.modeMenu.componentTextAlignment = NSTextAlignmentLeft;
    self.modeMenu.dropdownCornerRadius = TCSCALE(4.0);
    self.modeMenu.rowSeparatorColor = THEME_BACKGROUND_COLOR;
    
    UIImage *disclosureImg = [UIImage imageNamed:@"dropdown"];
    self.modeMenu.disclosureIndicatorImage = disclosureImg;
    
    CGRect newRect = _keyboardPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height;
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    [self.view addSubview:_keyboardPanel];
    _keyboardPanel.frame = newRect;
    
    [[TCMessageManager shared] clearMessageCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [_modeMenu closeAllComponentsAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMessage *message = [_messageArray objectAtIndex:indexPath.row];
    TCMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MESSAGE_CELL_ID forIndexPath:indexPath];
    [cell setMessage:message];
    __weak __typeof(self) weakSelf = self;
    cell.actionBlock = ^(TCMessageTableViewCell *cell, TCMessage *message) {
        NSString *companyStr = message.tip;
        if (companyStr && companyStr.length > 0)
        {
            NSArray *cidArray = [companyStr componentsSeparatedByString:@":"];
            if (cidArray)
            {
                NSString *cidStr = cidArray.firstObject;
                NSLog(@"icdStr :%@",cidStr);
                NSString *codeStr = nil;
                if (cidArray.count > 1)
                {
                    codeStr = [cidArray objectAtIndex:1];
                }
                NSInteger cid = cidStr.integerValue;
                
                if (message.mode == 1 && message.sub_mode == 1)
                {
                    [self resubmitWithCode:codeStr];
                    return ;
                }
                //添加主机\查看主机
                if (message.mode == 4)
                {
                    if (message.sub_mode == 4)
                    {
                        TCServerListViewController *listVC = [TCServerListViewController new];
                        [weakSelf.navigationController pushViewController:listVC animated:YES];
                        return;
                    }else if(message.sub_mode == 5)
                    {
                        TCAddServerViewController *addVC = [TCAddServerViewController new];
                        [weakSelf.navigationController pushViewController:addVC animated:YES];
                        return;
                    }
                }
                
                TCCorpProfileRequest *corpReq = [[TCCorpProfileRequest alloc] initWithCorpID:cid];
                [corpReq startWithSuccess:^(TCCorp *corp) {
                    NSLog(@"get copr info:%@ name:%@",corp.company_name,corp.name);
                    if (message.mode == 2 && message.sub_mode == 3)
                    {
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                        [TCPageManager loadCorpProfilePageWithCorp:corp];
                        return ;
                    }
                    if (message.sub_mode == 0)
                    {
                        NSArray *viewControllers = self.navigationController.viewControllers;
                        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                        [newVCS removeAllObjects];
                        [[TCCurrentCorp shared] setCid:cid];
                        TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:cid];
                        [newVCS addObject:homeVC];
                        TCStaffTableViewController *staffVC = [TCStaffTableViewController new];
                        [newVCS addObject:staffVC];
                        [weakSelf.navigationController setViewControllers:newVCS animated:YES];
                    }else if(message.sub_mode == 1)
                    {
                        [weakSelf resubmitWithCode:codeStr];
                    }else
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        [TCPageManager loadCorpPageWithCorpID:cid];
                    }
                    
                } failure:^(NSString *message) {
                    NSLog(@"get corp failed");
                    [MBProgressHUD showError:@"消息已失效，不能跳转" toView:nil];
                }];
            }
        }
    };
    return cell;
}

- (void) resubmitWithCode:(NSString*)inviteCode
{
    __weak __typeof(self) weakSelf = self;
    NSString *phoneNumStr = [[TCLocalAccount shared] mobile];
    TCInviteInfoRequest *infoReq = [[TCInviteInfoRequest alloc] initWithCode:inviteCode];
    [infoReq startWithSuccess:^(TCInviteInfo *info) {
        TCAcceptInviteRequest *acceptReq = [[TCAcceptInviteRequest alloc] initWithCode:inviteCode];
        [acceptReq startWithSuccess:^(NSString *message) {
            TCInviteProfileViewController *profileVC = [[TCInviteProfileViewController alloc] initWithCode:inviteCode joinSetting:info.setting shouldSetPassword:NO phoneNumber:phoneNumStr];
            [weakSelf.navigationController pushViewController:profileVC animated:YES];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
    }];
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TCCorpProfileRequest *corpReq = [[TCCorpProfileRequest alloc] initWithCorpID:27];
    [corpReq startWithSuccess:^(TCCorp *corp) {
        
    } failure:^(NSString *message) {
        
    }];
}

#pragma mark - DZNEmptyDataSetSource Methods
/*
 - (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
 {
 return [UIImage imageNamed:@"no_data"];
 }
 */

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(13.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"暂无消息" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}


#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return _modeMenuOptions.count;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return TCSCALE(32);
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return MAX(dropdownMenu.bounds.size.width/3, 125);
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:self.modeMenuOptions[_modeSelectedIndex]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCSCALE(12) weight:UIFontWeightLight],
                                                        NSForegroundColorAttributeName: THEME_PLACEHOLDER_COLOR}];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:self.modeMenuOptions[_modeSelectedIndex]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCSCALE(12) weight:UIFontWeightRegular],
                                                        NSForegroundColorAttributeName: THEME_TEXT_COLOR}];
    
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ShapeSelectView *shapeSelectView = (ShapeSelectView *)view;
    if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[ShapeSelectView class]]) {
        shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShapeSelectView class]) owner:nil options:nil] firstObject];
    }
    NSString *statusStr = self.modeMenuOptions[row];
    shapeSelectView.textLabel.text = statusStr;
    shapeSelectView.selected = _modeSelectedIndex == row;
    return shapeSelectView;
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self colorForRow:row];
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_keywordField resignFirstResponder];
    _modeSelectedIndex = row;
    [dropdownMenu reloadComponent:component];
    [dropdownMenu closeAllComponentsAnimated:YES];
    [self doSearchWithKeyword:_keywordField.text mode:_modeSelectedIndex];
}

- (UIColor *)colorForRow:(NSInteger)row {
    return DROPDOWN_CELL_BG_COLOR;
}


#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *word = textField.text;
    [self doSearchWithKeyword:word mode:_modeSelectedIndex];
    [textField resignFirstResponder];
    return YES;
}

- (void) onShowKeyboard:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = CGRectGetHeight([aValue CGRectValue]);
    
    CGRect newRect = _keyboardPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height - keyboardHeight - newRect.size.height + TCSCALE(10);
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.keyboardPanel.frame = newRect;
    }];
    [_modeMenu closeAllComponentsAnimated:YES];
}


- (void) onHideKeyboard:(NSNotification*)notification
{
    CGRect newRect = _keyboardPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height;
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.9
                     animations:^{
                         weakSelf.keyboardPanel.frame = newRect;
                     }];
    if (_keywordField.text.length == 0)
    {
        //[self reloadStaffArray];
    }
}


#pragma mark - extension
- (void) reloadMessages
{
    _pageIndex = 0;
    __weak __typeof(self) weakSelf = self;
    TCMessageListRequest *listReq = [TCMessageListRequest new];
    listReq.page = _pageIndex;
    [listReq startWithSuccess:^(NSArray<TCMessage *> *messageArray) {
        if (messageArray)
        {
            [weakSelf.messageArray removeAllObjects];
            [weakSelf.messageArray addObjectsFromArray:messageArray];
        }
        [weakSelf stopLoading];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (void) loadMoreMessages
{
    TCMessageListRequest *listReq = [TCMessageListRequest new];
    listReq.page = _pageIndex + 1;
    [listReq startWithSuccess:^(NSArray<TCMessage *> *messageArray) {
        [self.tableView.mj_footer endRefreshing];
        if (messageArray.count)
        {
            [self.messageArray addObjectsFromArray:messageArray];
            self.pageIndex ++;
        }else
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } failure:^(NSString *message) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (IBAction) onCloseKeyboard:(id)sender
{
    [_keywordField resignFirstResponder];
}

- (void) doSearchWithKeyword:(NSString*)keyword mode:(NSInteger)aMode
{
    __weak __typeof(self) weakSelf = self;
    TCSearchMessageRequest *req = [TCSearchMessageRequest new];
    req.keywords = keyword;
    req.mode = _modeSelectedIndex;
    [req startWithSuccess:^(NSArray<TCMessage *> *messageArray) {
        [weakSelf.messageArray removeAllObjects];
        [weakSelf.messageArray addObjectsFromArray:messageArray];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
    }];
}
@end
