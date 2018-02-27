//
//  TCServerListViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerListViewController.h"
#import "TCServerTableViewCell.h"
#import "TCServerDetailViewController.h"
#import "TCServerSearchRequest.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TCAddServerViewController.h"
#import "TCDataSync.h"
#import "TCConfiguration.h"
#import "TCServer+CoreDataClass.h"
#import "TCSearchFilterViewController.h"
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"

@interface TCServerListViewController ()<UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,TCDataSyncDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UITextField     *keywordField;
@property (nonatomic, weak) IBOutlet    UIView          *keyboradPanel;
@property (nonatomic, strong) NSMutableArray  *serverArray;
- (void) onShowKeyboard:(NSNotification*)notification;
- (void) onHideKeyboard:(NSNotification*)notification;
- (void) onDeleteServerNotification:(NSNotification*)sender;
- (void) onAddServerNotification:(NSNotification*)sender;
- (void) onFilterSearchNotification:(NSNotification*)sender;
- (void) onAddServerButton:(id)sender;
- (IBAction) onCloseKeyboard:(id)sender;
- (IBAction) onRefreshDataButton:(id)sender;
- (IBAction) onFilterButton:(id)sender;
- (IBAction) onCancelSearch:(id)sender;
- (void) doSearch:(NSString*)keyword provider:(NSArray<NSString*>*)providers
           region:(NSArray<NSString*>*)regions;
- (void) reloadServerList;
- (void) updateAddServerButton;
@end

@implementation TCServerListViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务器列表";
    [self updateAddServerButton];
    _serverArray = [NSMutableArray new];
    
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeleteServerNotification:)
                                                 name:NOTIFICATION_DEL_SERVER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAddServerNotification:)
                                                 name:NOTIFICATION_MODIFY_SERVER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAddServerNotification:)
                                                 name:NOTIFICATION_ADD_SERVER
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFilterSearchNotification:)
                                                 name:NOTIFICATION_DO_SEARCH
                                               object:nil];
    CGRect newRect = _keyboradPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height;
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    [self.view addSubview:_keyboradPanel];
    _keyboradPanel.frame = newRect;
    
    [self reloadServerList];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(onShowKeyboard:)
                       name:UIKeyboardWillShowNotification object:nil];
    [notiCenter addObserver:self selector:@selector(onHideKeyboard:)
                       name:UIKeyboardWillHideNotification object:nil];
    [[TCDataSync shared] addPermissionChangedObserver:self];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[TCDataSync shared] removePermissionChangedObserver:self];
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
    return _serverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CELL_REUSE_ID forIndexPath:indexPath];
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    [cell setServer:server];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithServerID:server.serverID name:server.name];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *word = textField.text;
    [self doSearch:word provider:@[] region:@[]];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - DZNEmptyDataSetSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"server_no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(12.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR2 forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"对不起，你还没有任何服务器" attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    BOOL canAdd = currentCorp.isAdmin ||
    [currentCorp havePermissionForFunc:FUNC_ID_ADD_SERVER] ||
    currentCorp.cid == 0;
    if (canAdd)
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
    return nil;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    BOOL canAdd = currentCorp.isAdmin ||
    [currentCorp havePermissionForFunc:FUNC_ID_ADD_SERVER] ||
    currentCorp.cid == 0;
    if (canAdd)
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
    return nil;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    TCAddServerViewController *addVC = [TCAddServerViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}


#pragma mark - extension
- (void) onShowKeyboard:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = CGRectGetHeight([aValue CGRectValue]);
    
    CGRect newRect = _keyboradPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height - keyboardHeight - newRect.size.height + TCSCALE(10);
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.keyboradPanel.frame = newRect;
    }];
    //[_statusMenu closeAllComponentsAnimated:YES];
}


- (void) onHideKeyboard:(NSNotification*)notification
{
    CGRect newRect = _keyboradPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height;
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.9
                     animations:^{
                         weakSelf.keyboradPanel.frame = newRect;
                     }];
    if (_keywordField.text.length == 0)
    {
        //[self reloadStaffArray];
    }
}

- (void) onDeleteServerNotification:(NSNotification*)sender
{
    [self reloadServerList];
}

- (void) onAddServerNotification:(NSNotification*)sender
{
    [self reloadServerList];
}

- (void) onFilterSearchNotification:(NSNotification*)sender
{
    NSDictionary *filterDict = sender.object;
    NSArray *providers = [filterDict objectForKey:@"provider"];
    NSArray *regions = [filterDict objectForKey:@"region"];
    NSString *keyword = _keywordField.text;
    if (keyword == nil)
    {
        keyword = @"";
    }
    [self doSearch:keyword provider:providers region:regions];
}

- (IBAction) onCloseKeyboard:(id)sender
{
    [_keywordField resignFirstResponder];
    NSString *keyword = _keywordField.text;
    if (keyword == nil)
    {
        keyword = @"";
    }
    [self doSearch:keyword provider:@[] region:@[]];
}

- (void) onAddServerButton:(id)sender
{
    TCAddServerViewController *addVC = [TCAddServerViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction) onRefreshDataButton:(id)sender
{
    [self reloadServerList];
}

- (IBAction) onFilterButton:(id)sender
{
    NSArray *providers = [[TCConfiguration shared] providerArray];
    TCSearchFilterViewController *filterVC = [[TCSearchFilterViewController alloc] initWithProviderArray:providers];
    [self presentViewController:filterVC animated:NO completion:nil];
}

- (IBAction) onCancelSearch:(id)sender
{
    [_keywordField resignFirstResponder];
}

- (void) doSearch:(NSString*)keyword provider:(NSArray<NSString*>*)providers
           region:(NSArray<NSString*>*)regions
{
    __weak __typeof(self) weakSelf = self;
    TCServerSearchRequest *request = [[TCServerSearchRequest alloc] initWithServerName:keyword regions:regions providers:providers];
    [request startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        [weakSelf.serverArray removeAllObjects];
        [weakSelf.serverArray addObjectsFromArray:serverArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        NSLog(@"search fail:%@",message);
    }];
}

- (void) reloadServerList
{
    __weak  __typeof(self)  weakSelf = self;
    [self startLoading];
    NSString *keyword = _keywordField.text;
    if (keyword == nil)
    {
        keyword = @"";
    }
    TCServerSearchRequest *request = [[TCServerSearchRequest alloc] initWithServerName:keyword regions:@[] providers:@[]];
    [request startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        [weakSelf stopLoading];
        [weakSelf.serverArray removeAllObjects];
        [weakSelf.serverArray addObjectsFromArray:serverArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
        [weakSelf stopLoading];
    }];
}

- (void) updateAddServerButton
{
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    if ( currentCorp.isAdmin ||
        [currentCorp havePermissionForFunc:FUNC_ID_ADD_SERVER] ||
        currentCorp.cid == 0)
    {
        UIImage *addServerImg = [UIImage imageNamed:@"server_nav_add"];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:addServerImg forState:UIControlStateNormal];
        [addButton sizeToFit];
        [addButton addTarget:self action:@selector(onAddServerButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        self.navigationItem.rightBarButtonItem = addItem;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - TCDataSyncDelegate
- (void) dataSync:(TCDataSync*)sync permissionChanged:(NSInteger)changed
{
    [self updateAddServerButton];
}
@end
