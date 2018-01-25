//
//  TCServerListViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerListViewController.h"
#import "TCClusterRequest.h"
#import "TCServerTableViewCell.h"
#import "TCServerDetailViewController.h"
#import "TCServerSearchRequest.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "TCAddServerViewController.h"
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"
#import "TCServer+CoreDataClass.h"
#import "TCClusterProvider+CoreDataClass.h"
#import "TCSearchFilterViewController.h"

@interface TCServerListViewController ()<UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
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
    UIImage *addServerImg = [UIImage imageNamed:@"server_nav_add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addServerImg forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddServerButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    _serverArray = [NSMutableArray new];
    
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeleteServerNotification:)
                                                 name:NOTIFICATION_DEL_SERVER
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
    
    [self startLoading];
    [self reloadServerList];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(onShowKeyboard:)
                       name:UIKeyboardWillShowNotification object:nil];
    [notiCenter addObserver:self selector:@selector(onHideKeyboard:)
                       name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    TCServerDetailViewController *detailVC = [[TCServerDetailViewController alloc] initWithServer:server];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"word:%@",textField.text);
    NSString *word = textField.text;
    /*
    if (word.length == 0)
    {
        [MBProgressHUD showError:@"请输入搜索词" toView:self.view];
        return NO;
    }
    NSString *trimedWord = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimedWord == NULL || trimedWord.length == 0)
    {
        [MBProgressHUD showError:@"不能搜索空白字符" toView:self.view];
        [textField setText:nil];
        return NO;
    }
     */
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
    TCServer *server = sender.object;
    if (server)
    {
        [_serverArray removeObject:server];
        [_tableView reloadData];
    }
}

- (void) onAddServerNotification:(NSNotification*)sender
{
    [self reloadServerList];
}

- (void) onFilterSearchNotification:(NSNotification*)sender
{
    NSLog(@"收到filter search通知");
    NSDictionary *filterDict = sender.object;
    NSArray *providers = [filterDict objectForKey:@"provider"];
    NSArray *regions = [filterDict objectForKey:@"region"];
    NSString *keyword = _keywordField.text;
    if (keyword == nil)
    {
        keyword = @"";
    }
    [self doSearch:@"" provider:providers region:regions];
}

- (IBAction) onCloseKeyboard:(id)sender
{
    [_keywordField resignFirstResponder];
    [self doSearch:@"" provider:@[] region:@[]];
}

- (void) onAddServerButton:(id)sender
{
    NSLog(@"on add server");
    TCAddServerViewController *addVC = [TCAddServerViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (IBAction) onRefreshDataButton:(id)sender
{
    NSLog(@"on refresh data button");
    [self reloadServerList];
}

- (IBAction) onFilterButton:(id)sender
{
    NSLog(@"on filter button");
    TCSearchFilterViewController *filterVC = [TCSearchFilterViewController new];
    filterVC.providesPresentationContextTransitionStyle = YES;
    filterVC.definesPresentationContext = YES;
    filterVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:filterVC animated:NO completion:nil];
}

- (IBAction) onCancelSearch:(id)sender
{
    [_keywordField resignFirstResponder];
}

- (void) doSearch:(NSString*)keyword provider:(NSArray<NSString*>*)providers
           region:(NSArray<NSString*>*)regions
{
    /*
    NSMutableString *providerStr = [NSMutableString new];
    for (int i = 0; i < providers.count; i++) {
        <#statements#>
    }
    NSMutableString *regionStr = [NSMutableString new];
    [NSString string]
     */
    //NSString *providerStr = [providers mj_JSONString];
    //NSString *regionsStr = [regions mj_JSONString];
    //NSString *providerStr = [providers componentsJoinedByString:@","];
    //NSString *regionsStr = [regions componentsJoinedByString:@","];
    //NSLog(@"providerStr:%@",providerStr);
    //NSLog(@"regionStr:%@",regionsStr);
    __weak __typeof(self) weakSelf = self;
    TCServerSearchRequest *request = [[TCServerSearchRequest alloc] initWithServerName:keyword regions:regions providers:providers];
    [request startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        NSLog(@"search resu:%@",serverArray);
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
    TCClusterRequest *request = [[TCClusterRequest alloc] init];
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
@end
