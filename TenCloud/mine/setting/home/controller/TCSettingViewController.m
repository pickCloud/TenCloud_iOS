//
//  TCSettingViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/27.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSettingViewController.h"
#import "TCTextTableViewCell.h"
#import "TCCellData.h"
#import "TCLoginViewController.h"
#import "TCAccountSecurityViewController.h"
#define SETTING_TEXT_CELL_REUSE_ID  @"SETTING_TEXT_CELL_REUSE_ID"

@interface TCSettingViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UIView          *footerView;
@property (nonatomic, weak) IBOutlet    UILabel         *versionLabel;
@property (nonatomic, strong)   NSMutableArray          *cellItemArray;
- (IBAction) onExitAccount:(id)sender;
@end

@implementation TCSettingViewController

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
    self.title = @"设置";
    UINib *textCellNib = [UINib nibWithNibName:@"TCTextTableViewCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:SETTING_TEXT_CELL_REUSE_ID];
    self.tableView.tableFooterView = _footerView;
    
    _cellItemArray = [NSMutableArray new];
    TCCellData *data1 = [TCCellData new];
    data1.title = @"账号安全";
    data1.initialValue = @" ";
    data1.type = TCCellTypeText;
    [_cellItemArray addObject:data1];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
#if ONLINE_ENVIROMENT
    NSString *server = @"正式服务器";
#else
    NSString *server = @"测试服务器";
#endif
    NSString *desc = [NSString stringWithFormat:@"%@ %@",version,server];
    _versionLabel.text = desc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extension
- (IBAction) onExitAccount:(id)sender
{
    /*
    UIAlertController *alertController = nil;
    alertController = [UIAlertController alertControllerWithTitle:@"确定退出登录?"
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor grayColor];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[TCLocalAccount shared] logout];
        [[TCCurrentCorp shared] reset];
        TCLoginViewController *loginVC = [TCLoginViewController new];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginNav];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:exitAction];
    [alertController presentationController];
    [self presentViewController:alertController animated:YES completion:nil];
     */
    
    TCConfirmBlock confirmBlock = ^(TCConfirmView *view){
        [[TCLocalAccount shared] logout];
        [[TCCurrentCorp shared] reset];
        TCLoginViewController *loginVC = [TCLoginViewController new];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:loginNav];
    };
    [TCAlertController presentFromController:self
                                       title:@"确定退出登录?"
                           confirmButtonName:@"退出登录"
                                confirmBlock:confirmBlock
                                 cancelBlock:nil];
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
    TCTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SETTING_TEXT_CELL_REUSE_ID forIndexPath:indexPath];
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
        TCAccountSecurityViewController *securityVC = [TCAccountSecurityViewController new];
        [self.navigationController pushViewController:securityVC animated:YES];
    }
}

@end
