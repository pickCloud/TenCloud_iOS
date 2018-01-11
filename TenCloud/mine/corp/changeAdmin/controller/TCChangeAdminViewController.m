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
#define CHANGE_ADMIN_CELL_ID    @"CHANGE_ADMIN_CELL_ID"

@interface TCChangeAdminViewController ()
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topHeightConstraint;
@property (nonatomic, weak) IBOutlet    UILabel             *titleLabel;
@property (nonatomic, weak) IBOutlet    UITableView         *tableView;
- (IBAction) onCloseButton:(id)sender;
- (IBAction) onConfirmButton:(id)sender;
@end

@implementation TCChangeAdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_staffArray = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
    if (IS_iPhoneX)
    {
        _topHeightConstraint.constant = 64+27;
    }
    
    self.titleLabel.text = @"更换管理员";
    
    UINib *cellNib = [UINib nibWithNibName:@"TCChangeAdminTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:CHANGE_ADMIN_CELL_ID];
    _tableView.tableFooterView = [UIView new];
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
    __weak __typeof(self) weakSelf = self;

}

- (void) reloadStaffArray
{
    __weak  __typeof(self) weakSelf = self;
    TCStaffListRequest *req = [[TCStaffListRequest alloc] init];
    [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
        //[weakSelf.staffArray removeAllObjects];
        //[weakSelf stopLoading];
        //[weakSelf.staffArray addObjectsFromArray:staffArray];
        //[weakSelf.tableView reloadData];
        //[weakSelf.staffArray removeA]
        
        //[weakSelf.staffArray removeAllObjects];
        //[weakSelf.staffArray addObjectsFromArray:staffArray];
        weakSelf.staffArray = staffArray;
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _staffArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    TCStaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STAFF_CELL_ID forIndexPath:indexPath];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    [cell setStaff:staff];
    return cell;
     */
    TCChangeAdminTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHANGE_ADMIN_CELL_ID forIndexPath:indexPath];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    [cell setStaff:staff];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    if (!staff.is_admin)
    {
        __weak __typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定更换管理员?"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        alertController.view.tintColor = [UIColor grayColor];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"更换" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [MMProgressHUD showWithStatus:@"更换管理员中..."];
            TCSetAdminRequest *setReq = [TCSetAdminRequest new];
            setReq.uid = staff.uid;
            [setReq startWithSuccess:^(NSString *message) {
                //[weakSelf reloadStaffArray];
                TCStaffListRequest *req = [[TCStaffListRequest alloc] init];
                [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
                    //[weakSelf.staffArray removeAllObjects];
                    //[weakSelf.staffArray addObjectsFromArray:staffArray];
                    weakSelf.staffArray = staffArray;
                    [weakSelf.tableView reloadData];
                    [MMProgressHUD dismissWithSuccess:@"更换成功" title:nil afterDelay:1.32];
                } failure:^(NSString *message) {
                    [MMProgressHUD dismissWithError:message afterDelay:1.32];
                }];
            } failure:^(NSString *message) {
                [MMProgressHUD dismissWithError:message afterDelay:1.32];
            }];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:restartAction];
        [alertController presentationController];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    /*
    TCStaffProfileViewController *profileVC = [[TCStaffProfileViewController alloc] initWithStaff:staff];
    [self.navigationController pushViewController:profileVC animated:YES];
     */
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
    return [[NSAttributedString alloc] initWithString:@"无员工记录" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

@end
