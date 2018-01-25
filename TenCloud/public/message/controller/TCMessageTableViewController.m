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
#import "TCMessageListRequest.h"
#import "TCTextRefreshAutoFooter.h"

#import "TCAcceptInviteViewController.h"
#import "TCInviteLoginViewController.h"

//for test
#import "TCCorp+CoreDataClass.h"

#define MESSAGE_CELL_ID             @"MESSAGE_CELL_ID"

@interface TCMessageTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, assign)           NSInteger       status;
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *messageArray;
@property (nonatomic, assign)   NSInteger               pageIndex;
- (void) reloadMessages;
- (void) loadMoreMessages;
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

- (instancetype) initWithStatus:(NSInteger)status
{
    self = [super init];
    if (self)
    {
        _status = status;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageArray = [NSMutableArray new];
    
    UINib *cellNib = [UINib nibWithNibName:@"TCMessageTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:MESSAGE_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    /*
    TCSearchMessageRequest *searchReq = [TCSearchMessageRequest new];
    searchReq.status = _status;
    searchReq.mode = 1;
    searchReq.keywords = @"";
    [searchReq startWithSuccess:^(NSArray<TCMessage*> *messageArray) {
        if (messageArray)
        {
            [weakSelf.messageArray addObjectsFromArray:messageArray];
        }
        [weakSelf stopLoading];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
        [MBProgressHUD showError:message toView:nil];
    }];
     */
    [self reloadMessages];
    
    TCTextRefreshAutoFooter *footer = [TCTextRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessages)];
    footer.automaticallyRefresh = YES;
    footer.automaticallyHidden = YES;
    self.tableView.mj_footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                TCCorpProfileRequest *corpReq = [[TCCorpProfileRequest alloc] initWithCorpID:cid];
                [corpReq startWithSuccess:^(TCCorp *corp) {
                    NSLog(@"get copr info:%@ name:%@",corp.company_name,corp.name);
                    /*
                    if ([[TCCurrentCorp shared] cid] == cid)
                    {
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }else
                    {
                        TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:cid];
                        NSArray *viewControllers = self.navigationController.viewControllers;
                        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                        [newVCS removeAllObjects];
                        [newVCS addObject:homeVC];
                        [weakSelf.navigationController setViewControllers:newVCS animated:YES];
                    }
                     */

                    if (message.sub_mode == 0)
                    {
                        NSArray *viewControllers = self.navigationController.viewControllers;
                        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                        [newVCS removeAllObjects];
                        TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:cid];
                        [newVCS addObject:homeVC];
                        TCStaffTableViewController *staffVC = [TCStaffTableViewController new];
                        [newVCS addObject:staffVC];
                        [weakSelf.navigationController setViewControllers:newVCS animated:YES];
                    }else if(message.sub_mode == 1)
                    {
                        /*
                        if ([[TCLocalAccount shared] isLogin])
                        {
                            TCAcceptInviteViewController *acceptVC = [[TCAcceptInviteViewController alloc] initWithCode:codeStr];
                            [weakSelf.navigationController pushViewController:acceptVC animated:YES];
                        }else
                        {
                            TCInviteLoginViewController *loginVC = [[TCInviteLoginViewController alloc] initWithCode:codeStr];
                            [weakSelf.navigationController pushViewController:loginVC animated:YES];
                        }
                         */
                        [weakSelf resubmitWithCode:codeStr];
                    }else
                    {
                        NSArray *viewControllers = self.navigationController.viewControllers;
                        NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                        [newVCS removeAllObjects];
                        TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:cid];
                        [newVCS addObject:homeVC];
                        [weakSelf.navigationController setViewControllers:newVCS animated:YES];
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

- (void) resubmitWithCode:(NSString*)codeStr
{
    if ([[TCLocalAccount shared] isLogin])
    {
        TCAcceptInviteViewController *acceptVC = [[TCAcceptInviteViewController alloc] initWithCode:codeStr];
        [self.navigationController pushViewController:acceptVC animated:YES];
    }else
    {
        TCInviteLoginViewController *loginVC = [[TCInviteLoginViewController alloc] initWithCode:codeStr];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
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


#pragma mark - extension
- (void) reloadMessages
{
    _pageIndex = 0;
    __weak __typeof(self) weakSelf = self;
    TCMessageListRequest *listReq = [TCMessageListRequest new];
    listReq.status = _status;
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
    __weak __typeof(self) weakSelf = self;
    TCMessageListRequest *listReq = [TCMessageListRequest new];
    listReq.status = _status;
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
@end
