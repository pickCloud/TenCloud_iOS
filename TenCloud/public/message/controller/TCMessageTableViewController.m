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
#define MESSAGE_CELL_ID             @"MESSAGE_CELL_ID"

@interface TCMessageTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, assign)           NSInteger       status;
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *messageArray;
@end

@implementation TCMessageTableViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
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
    TCMessageListRequest *listReq = [TCMessageListRequest new];
    listReq.status = _status;
    listReq.page = 0;
    [listReq startWithSuccess:^(NSArray<TCMessage *> *messageArray) {
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
    cell.actionBlock = ^(TCMessageTableViewCell *cell, TCMessage *message) {
        NSString *companyStr = message.tip;
        if (companyStr && companyStr.length > 0)
        {
            NSArray *cidArray = [companyStr componentsSeparatedByString:@":"];
            if (cidArray)
            {
                NSString *cidStr = cidArray.firstObject;
                NSInteger cid = cidStr.integerValue;
                if ([[TCCurrentCorp shared] cid] == cid)
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else
                {
                    TCCorpHomeViewController *homeVC = [[TCCorpHomeViewController alloc] initWithCorpID:cid];
                    NSArray *viewControllers = self.navigationController.viewControllers;
                    NSMutableArray *newVCS = [NSMutableArray arrayWithArray:viewControllers];
                    [newVCS removeLastObject];
                    [newVCS addObject:homeVC];
                    [self.navigationController setViewControllers:newVCS animated:YES];
                }
            }
        }
    };
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

@end