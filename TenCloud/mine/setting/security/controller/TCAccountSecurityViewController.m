//
//  TCAccountSecurityViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAccountSecurityViewController.h"
#import "TCTextTableViewCell.h"
#import "TCModifyPasswordViewController.h"
#define SECURITY_CELL_REUSE_ID       @"SECURITY_CELL_REUSE_ID"

@interface TCAccountSecurityViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)           NSMutableArray  *cellItemArray;
@end

@implementation TCAccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号安全";
    UINib *textCellNib = [UINib nibWithNibName:@"TCTextTableViewCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:SECURITY_CELL_REUSE_ID];
    self.tableView.tableFooterView = [UIView new];
    
    TCLocalAccount *account = [TCLocalAccount shared];
    _cellItemArray = [NSMutableArray new];
    TCCellData *data1 = [TCCellData new];
    data1.title = @"手机号码";
    data1.initialValue = account.hiddenMobile;
    data1.type = TCCellTypeText;
    [_cellItemArray addObject:data1];
    
    TCCellData *data2 = [TCCellData new];
    data2.title = @"注册时间";
    data2.initialValue = account.createTime;
    data2.type = TCCellTypeText;
    data2.hideDetailView = YES;
    [_cellItemArray addObject:data2];
    
    TCCellData *data3 = [TCCellData new];
    data3.title = @"修改密码";
    data3.type = TCCellTypeText;
    [_cellItemArray addObject:data3];
    
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
    return _cellItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCellData *data = [_cellItemArray objectAtIndex:indexPath.row];
    TCTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECURITY_CELL_REUSE_ID forIndexPath:indexPath];
    cell.fatherViewController = self;
    cell.data = data;
    return cell;
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
 {
 return 0.01f;
 }
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0)
    {
        //TCModifyPasswordViewController *modifyVC = [TCModifyPasswordViewController new];
        //[self.navigationController pushViewController:modifyVC animated:YES];
    }else if(indexPath.row == 2)
    {
        TCModifyPasswordViewController *modifyVC = [TCModifyPasswordViewController new];
        [self.navigationController pushViewController:modifyVC animated:YES];
    }
}

@end
