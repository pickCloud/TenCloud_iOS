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
#import "TCAcceptInviteViewController.h"
#import "TCInviteLoginViewController.h"

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
    self.title = @"我的企业";
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
    FEPopupMenuItem *item1 = [[FEPopupMenuItem alloc] initWithTitle:@"添加企业" iconImage:nil action:^{
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
    /*
    TCServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CELL_REUSE_ID forIndexPath:indexPath];
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    [cell setServer:server];
     */
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TCListCorp *selectedCorp = [self.corpArray objectAtIndex:indexPath.row];
    if (selectedCorp.status == -1)
    {
        [MBProgressHUD showError:@"暂无未通过处理页面" toView:nil];
    }else if(selectedCorp.status == 2)
    {
        
    }else if(selectedCorp.status == 5 || selectedCorp.status == 1)
    {
        NSLog(@"select corp code:%@",selectedCorp.code);
        NSString *inviteCode = selectedCorp.code;
        if ([[TCLocalAccount shared] isLogin])
        {
            TCAcceptInviteViewController *acceptVC = [[TCAcceptInviteViewController alloc] initWithCode:inviteCode];
            [self.navigationController pushViewController:acceptVC animated:YES];
        }else
        {
            TCInviteLoginViewController *loginVC = [[TCInviteLoginViewController alloc] initWithCode:inviteCode];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else
    {
        __weak __typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定切换到企业身份?"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = [UIColor grayColor];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *switchAction = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [MMProgressHUD showWithStatus:@"切换身份中"];
            [[TCCurrentCorp shared] setCid:selectedCorp.cid];
            UIViewController *homeVC = nil;
            homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:selectedCorp.cid];
            NSArray *viewControllers = weakSelf.navigationController.viewControllers;
            NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
            [newVCS removeAllObjects];
            [newVCS addObject:homeVC];
            [weakSelf.navigationController setViewControllers:newVCS animated:YES];
            [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:1.32];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:switchAction];
        [alertController presentationController];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
    return [[NSAttributedString alloc] initWithString:@"您尚未创建或加入企业" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}


#pragma mark - extension
- (void) reloadCorpArray
{
    __weak __typeof(self) weakSelf = self;
    TCCorpListRequest   *request = [[TCCorpListRequest alloc] initWithStatus:7];
    [request startWithSuccess:^(NSArray<TCCorp *> *corpArray) {
        NSLog(@"corp list:%@",corpArray);
        [weakSelf.corpArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.corpArray addObjectsFromArray:corpArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        NSLog(@"my corp req failed:%@",message);
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
