//
//  TCTemplateTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCTemplateTableViewController.h"
#import "TCTemplateTableViewCell.h"
#import "TCCurrentCorp.h"
#import "TCTemplateListRequest.h"
#import "TCAddTemplateViewController.h"
#import "TCModifyTemplateViewController.h"
#import "TCDeleteTemplateRequest.h"
#import "TCTemplate+CoreDataClass.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TCEditingPermission.h"
#import "TCPermissionViewController.h"

#define TEMPLATE_CELL_REUSE_ID      @"TEMPLATE_CELL_REUSE_ID"

@interface TCTemplateTableViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *templateArray;
- (void) onAddTemplateButton:(id)sender;
- (void) onReloadTemplateNotification;
- (void) onUpdateTemplateUINotification;
- (void) reloadTemplateArray;
- (void) deleteTemplateAtIndexPath:(NSIndexPath*)path;
@end

@implementation TCTemplateTableViewController

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
    self.title = @"权限模版管理";
    _templateArray = [NSMutableArray new];
    
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    if ( currentCorp.isAdmin ||
        [currentCorp havePermissionForFunc:FUNC_ID_ADD_TEMPLATE] )
    {
        UIImage *addTmplImg = [UIImage imageNamed:@"template_add"];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:addTmplImg forState:UIControlStateNormal];
        [addButton sizeToFit];
        [addButton addTarget:self action:@selector(onAddTemplateButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        self.navigationItem.rightBarButtonItem = addItem;
    }
    
    UINib *cellNib = [UINib nibWithNibName:@"TCTemplateTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:TEMPLATE_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReloadTemplateNotification)
                                                 name:NOTIFICATION_ADD_TEMPLATE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdateTemplateUINotification)
                                                 name:NOTIFICATION_MODIFY_TEMPLATE
                                               object:nil];
    
    [self startLoading];
    [self reloadTemplateArray];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return _templateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEMPLATE_CELL_REUSE_ID forIndexPath:indexPath];
    TCTemplate *template = [_templateArray objectAtIndex:indexPath.row];
    [cell setTemplate:template];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TCTemplate *tmpl = [_templateArray objectAtIndex:indexPath.row];
    
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    BOOL havePermission = currentCorp.isAdmin ||
    [currentCorp havePermissionForFunc:FUNC_ID_MODIFY_TEMPLATE];
    BOOL editable = tmpl.type != 0;
    if ( havePermission && editable )
    {
        TCModifyTemplateViewController *modifyVC = [[TCModifyTemplateViewController alloc] initWithTemplate:tmpl];
        [self.navigationController pushViewController:modifyVC animated:YES];
    }else
    {
        [[TCEditingPermission shared] reset];
        [[TCEditingPermission shared] setTemplate:tmpl];
        if (tmpl.type != 0)
        {
            [[TCEditingPermission shared] readyForPreview];
        }
        TCPermissionViewController *perVC = [TCPermissionViewController new];
        perVC.state = PermissionVCPreviewPermission;
        perVC.tmpl = tmpl;
        [self presentViewController:perVC animated:YES completion:nil];
    }
}

- (BOOL) tableView:(UITableView*)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    BOOL canDelete = currentCorp.isAdmin ||
    [currentCorp havePermissionForFunc:FUNC_ID_DEL_TEMPLATE];
    return canDelete;
}

- (void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteTemplateAtIndexPath:indexPath];
    }
}


#pragma mark - extension
- (void) onAddTemplateButton:(id)sender
{
    TCAddTemplateViewController *addVC = [TCAddTemplateViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void) onReloadTemplateNotification
{
    [self reloadTemplateArray];
}

- (void) onUpdateTemplateUINotification
{
    [self.tableView reloadData];
}

- (void) reloadTemplateArray
{
    __weak __typeof(self) weakSelf = self;
    NSInteger cid = [[TCCurrentCorp shared] cid];
    TCTemplateListRequest *request = [[TCTemplateListRequest alloc] initWithCorpID:cid];
    [request startWithSuccess:^(NSArray<TCTemplate *> *templateArray) {
        [weakSelf.templateArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.templateArray addObjectsFromArray:templateArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
}

- (void) deleteTemplateAtIndexPath:(NSIndexPath*)path
{
    TCTemplate *tmpl = [_templateArray objectAtIndex:path.row];
    __weak __typeof(self) weakSelf = self;
    NSString *tip = [NSString stringWithFormat:@"确定删除 %@ 模版?",tmpl.name];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tip
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor grayColor];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        TCDeleteTemplateRequest *delReq = [[TCDeleteTemplateRequest alloc] initWithTemplateID:tmpl.tid];
        [delReq startWithSuccess:^(NSString *message) {
            [weakSelf.templateArray removeObjectAtIndex:path.row];
            NSArray *paths = [NSArray arrayWithObject:path];
            [weakSelf.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
        }];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController presentationController];
    [self presentViewController:alertController animated:YES completion:nil];
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
    return [[NSAttributedString alloc] initWithString:@"暂无模版" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self onAddTemplateButton:nil];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self onAddTemplateButton:nil];
}
@end
