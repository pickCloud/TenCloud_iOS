//
//  TCChangeAdminViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCChangeAdminViewController.h"
#import "TCChangeAdminTableViewCell.h"
#import "TCStaff+CoreDataClass.h"
#import "TCSetAdminRequest.h"
#import "TCStaffListRequest.h"
#import "TCStaffSearchRequest.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#define CHANGE_ADMIN_CELL_ID    @"CHANGE_ADMIN_CELL_ID"

@interface TCChangeAdminViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topHeightConstraint;
@property (nonatomic, weak) IBOutlet    UILabel             *titleLabel;
@property (nonatomic, weak) IBOutlet    UITableView         *tableView;
@property (nonatomic, weak) IBOutlet    UITextField         *keywordField;
@property (nonatomic, weak) IBOutlet    UIView              *keyboardPanel;
@property (nonatomic, weak) IBOutlet    UIView              *navBarView;
- (void) onShowKeyboard:(NSNotification*)notification;
- (void) onHideKeyboard:(NSNotification*)notification;
- (IBAction) onCloseButton:(id)sender;
- (IBAction) onConfirmButton:(id)sender;
- (IBAction) onCloseKeyboard:(id)sender;
- (void) doSearchWithKeyword:(NSString*)keyword;
@end

@implementation TCChangeAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_iPhoneX)
    {
        _topHeightConstraint.constant = 64+27;
    }
    
    self.titleLabel.text = @"更换管理员";
    
    UINib *cellNib = [UINib nibWithNibName:@"TCChangeAdminTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:CHANGE_ADMIN_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    _staffArray = [NSMutableArray new];
    [self startLoading];
    [self reloadStaffArray];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(onShowKeyboard:)
                       name:UIKeyboardWillShowNotification object:nil];
    [notiCenter addObserver:self selector:@selector(onHideKeyboard:)
                       name:UIKeyboardWillHideNotification object:nil];
    
    CGRect newRect = _keyboardPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height;
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    [self.view addSubview:_keyboardPanel];
    _keyboardPanel.frame = newRect;
    [self.view bringSubviewToFront:_navBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - extension
- (IBAction) onCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) onConfirmButton:(id)sender
{
    
}

- (void) doSearchWithKeyword:(NSString*)keyword
{
    __weak __typeof(self) weakSelf = self;
    TCStaffSearchRequest *req = [TCStaffSearchRequest new];
    req.keyword = keyword;
    req.status = STAFF_STATUS_PASS;
    [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
        [weakSelf.staffArray removeAllObjects];
        [weakSelf.staffArray addObjectsFromArray:staffArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message, NSInteger errorCode) {
        [MBProgressHUD showError:message toView:nil];
    }];
}

- (void) reloadStaffArray
{
    __weak  __typeof(self) weakSelf = self;
    TCStaffListRequest *req = [[TCStaffListRequest alloc] init];
    [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
        NSMutableArray *validStaffArray = [NSMutableArray new];
        for (TCStaff *tmpStaff in staffArray)
        {
            if (tmpStaff.status == STAFF_STATUS_PASS ||
                tmpStaff.status == STAFF_STATUS_FOUNDER)
            {
                [validStaffArray addObject:tmpStaff];
            }
        }
        weakSelf.staffArray = validStaffArray;
        [weakSelf stopLoading];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
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
    //[_modeMenu closeAllComponentsAnimated:YES];
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

- (IBAction) onCloseKeyboard:(id)sender
{
    [_keywordField resignFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _staffArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCChangeAdminTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHANGE_ADMIN_CELL_ID forIndexPath:indexPath];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    [cell setStaff:staff];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    if (!staff.is_admin)
    {
        __weak __typeof(self) weakSelf = self;
        NSString *text = @"确定更换管理员?";
        TCConfirmBlock block = ^(TCConfirmView *view){
            [MMProgressHUD showWithStatus:@"更换管理员中..."];
            TCSetAdminRequest *setReq = [TCSetAdminRequest new];
            setReq.uid = staff.uid;
            [setReq startWithSuccess:^(NSString *message) {
                TCStaffListRequest *req = [[TCStaffListRequest alloc] init];
                [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
                    weakSelf.currentStaff.is_admin = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_ADMIN object:nil];
                    NSMutableArray *validStaffArray = [NSMutableArray new];
                    for (TCStaff *tmpStaff in staffArray)
                    {
                        if (tmpStaff.status == STAFF_STATUS_PASS ||
                            tmpStaff.status == STAFF_STATUS_FOUNDER)
                        {
                            [validStaffArray addObject:tmpStaff];
                        }
                    }
                    weakSelf.staffArray = validStaffArray;
                    [weakSelf.tableView reloadData];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    [MMProgressHUD dismissWithSuccess:@"更换成功" title:nil afterDelay:1.5];
                } failure:^(NSString *message) {
                    [MMProgressHUD dismissWithError:message afterDelay:1.32];
                }];
            } failure:^(NSString *message) {
                [MMProgressHUD dismissWithError:message afterDelay:1.32];
            }];
        };
        [TCAlertController presentFromController:self
                                           title:text
                               confirmButtonName:@"更换"
                                    confirmBlock:block
                                     cancelBlock:nil];
    }
}


#pragma mark - DZNEmptyDataSetSource Methods
 - (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
 {
     return [UIImage imageNamed:@"default_no_data"];
 }

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(13.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR2 forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"无搜索结果" attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -TCSCALE(50);
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}


#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *word = textField.text;
    [self doSearchWithKeyword:word];
    [textField resignFirstResponder];
    return YES;
}


@end
