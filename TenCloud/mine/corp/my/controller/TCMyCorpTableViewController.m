//
//  TCMyCorpTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCMyCorpTableViewController.h"
#import "TCMyCorpTableViewCell.h"
#import "TCCorpListRequest.h"
#import "TCAddCorpViewController.h"
#import "TCJoinCorpViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TCCorpHomeViewController.h"
#import "TCListCorp+CoreDataClass.h"
#import "FEPopupMenuController.h"
#import "TCInviteInfoRequest.h"
#import "TCAcceptInviteRequest.h"
#import "TCInviteProfileViewController.h"
#import "TCInviteInfo+CoreDataClass.h"

#define MY_CORP_CELL_REUSE_ID   @"MY_CORP_CELL_REUSE_ID"

@interface TCMyCorpTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *corpArray;
@property (nonatomic, strong)   FEPopupMenuController   *menuController;
- (void) onAddCorpButton:(id)sender;
- (void) onAddCorpNotification;
- (void) reloadCorpArray;
@end

@implementation TCMyCorpTableViewController

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
    self.title = @"我的公司";
    _corpArray = [NSMutableArray new];
    
    UIImage *addServerImg = [UIImage imageNamed:@"corp_nav_add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addServerImg forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddCorpButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCMyCorpTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:MY_CORP_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAddCorpNotification) name:NOTIFICATION_ADD_CORP
                                               object:nil];
    
    [self startLoading];
    [self reloadCorpArray];
    
    __weak __typeof(self) weakSelf = self;
    FEPopupMenuItem *item1 = [[FEPopupMenuItem alloc] initWithTitle:@"添加新企业" iconImage:nil action:^{
        TCAddCorpViewController *addVC = [TCAddCorpViewController new];
        [weakSelf.navigationController pushViewController:addVC animated:YES];
    }];
    item1.titleColor = THEME_TEXT_COLOR;
    FEPopupMenuItem *item2 = [[FEPopupMenuItem alloc] initWithTitle:@"加入已有企业" iconImage:nil action:^{
        TCJoinCorpViewController *joinVC = [TCJoinCorpViewController new];
        [weakSelf.navigationController pushViewController:joinVC animated:YES];
    }];
    item2.titleColor = THEME_TEXT_COLOR;
    self.menuController = [[FEPopupMenuController alloc] initWithItems:@[item2,item1]];
    self.menuController.isShowArrow = NO;
    self.menuController.contentViewWidth = 180;
    self.menuController.contentViewBackgroundColor = THEME_NAVBAR_TITLE_COLOR;
    self.menuController.itemSeparatorLineColor = TABLE_CELL_BG_COLOR;
    self.menuController.contentViewCornerRadius = TCSCALE(4.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return _corpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMyCorpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_CORP_CELL_REUSE_ID forIndexPath:indexPath];
    TCCorp *corp = [_corpArray objectAtIndex:indexPath.row];
    [cell setCorp:corp];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    __weak __typeof(self) weakSelf = self;
    TCListCorp *selectedCorp = [self.corpArray objectAtIndex:indexPath.row];
    if (selectedCorp.status == -1)
    {
        [MBProgressHUD showError:@"暂无未通过处理页面" toView:nil];
    }else if(selectedCorp.status == STAFF_STATUS_PENDING)
    {
        //此场景不做任何响应动作
    }else if(selectedCorp.status == STAFF_STATUS_REJECT ||
             selectedCorp.status == STAFF_STATUS_WAITING)
    {
        NSString *tip = @"确定重新申请?";
        NSString *confirmBtnName = @"重新申请";
        if (selectedCorp.status == STAFF_STATUS_WAITING)
        {
            tip = @"确定申请加入?";
            confirmBtnName = @"申请加入";
        }
        TCConfirmBlock block = ^(TCConfirmView *view){
            NSString *inviteCode = selectedCorp.code;
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
        };
        [TCAlertController presentFromController:self
                                           title:tip
                               confirmButtonName:confirmBtnName
                                    confirmBlock:block
                                     cancelBlock:nil];
    }else
    {
        NSString *tip = @"确定切换到企业身份?";
        TCConfirmBlock block = ^(TCConfirmView *view){
            [MMProgressHUD showWithStatus:@"切换身份中"];
            [[TCCurrentCorp shared] setCid:selectedCorp.cid];
            UIViewController *homeVC = nil;
            homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:selectedCorp.cid];
            NSArray *viewControllers = weakSelf.navigationController.viewControllers;
            NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
            [newVCS removeAllObjects];
            [newVCS addObject:homeVC];
            [weakSelf.navigationController setViewControllers:newVCS animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CORP_CHANGE object:nil];
            [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:1.32];
        };
        [TCAlertController presentFromController:self
                                           title:tip
                               confirmButtonName:@"切换"
                                    confirmBlock:block
                                     cancelBlock:nil];
    }
}


#pragma mark - DZNEmptyDataSetSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"corp_no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(12.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR2 forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"对不起，你还没有任何企业" attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"马上去添加";
    UIFont *textFont = TCFont(14.0);
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:textFont forKey:NSFontAttributeName];
    if (state == UIControlStateNormal)
    {
        [attributes setObject:THEME_TINT_COLOR forKey:NSForegroundColorAttributeName];
    }else
    {
        [attributes setObject:THEME_TINT_P_COLOR forKey:NSForegroundColorAttributeName];
    }
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(0.0, TCSCALE(-112), 0.0, TCSCALE(-112));
    UIImage *image = nil;
    if (state == UIControlStateNormal)
    {
        image = [UIImage imageNamed:@"no_data_button_bg"];
    }else
    {
        image = [UIImage imageNamed:@"no_data_button_bg_p"];
    }
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    //UIEdgeInsets inset = self.tableView.contentInset;
    //return inset.top / 2.0 - self.tableView.frame.size.height / 20;
    return -TCSCALE(20);
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    TCAddCorpViewController *addVC = [TCAddCorpViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}


#pragma mark - extension
- (void) reloadCorpArray
{
    __weak __typeof(self) weakSelf = self;
    TCCorpListRequest   *request = [[TCCorpListRequest alloc] initWithStatus:7];
    [request startWithSuccess:^(NSArray<TCCorp *> *corpArray) {
        [weakSelf.corpArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.corpArray addObjectsFromArray:corpArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        NSLog(@"my corp req failed:%@",message);
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (void) onAddCorpButton:(id)sender
{
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat posY = navBarRect.origin.y + navBarRect.size.height;
    CGFloat posX = navBarRect.size.width - self.menuController.contentViewWidth - 20;
    CGPoint pos = CGPointMake(posX, posY);
    [self.menuController showInViewController:self atPosition:pos];
}

- (void) onAddCorpNotification
{
    [self reloadCorpArray];
}
@end
