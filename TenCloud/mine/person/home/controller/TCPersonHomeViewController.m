//
//  TCPersonHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/22.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPersonHomeViewController.h"
#import "TCIconTableViewCell.h"
#import "TCCustomerServiceViewController.h"


#define PERSON_HOME_CELL_REUSE_ID       @"PERSON_HOME_CELL_REUSE_ID"

@interface TCPersonHomeViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UIButton        *avatarButton;
@property (nonatomic, weak) IBOutlet    UILabel         *nameLabel;
@property (nonatomic, weak) IBOutlet    UILabel         *phoneLabel;
@property (nonatomic, weak) IBOutlet    UIImageView     *certificatedImageView;
- (IBAction) onProfilePage:(id)sender;
@end

@implementation TCPersonHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    UINib *cellNib = [UINib nibWithNibName:@"TCIconTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:PERSON_HOME_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    
    NSString *name = [[TCLocalAccount shared] name];
    if (!name || name.length == 0)
    {
        NSInteger uid = [[TCLocalAccount shared] userID];
        name = [NSString stringWithFormat:@"用户%ld",uid];
    }
    _nameLabel.text = name;
    NSString *rawPhoneStr = [[TCLocalAccount shared] mobile];
    NSString *filteredPhone = rawPhoneStr;
    if (rawPhoneStr.length >= 11)
    {
        NSRange replaceRange = NSMakeRange(3, 4);
        filteredPhone = [rawPhoneStr stringByReplacingCharactersInRange:replaceRange withString:@"****"];
    }
    _phoneLabel.text = filteredPhone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PERSON_HOME_CELL_REUSE_ID forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [cell setIcon:@"person_home_corp" title:@"我的公司" desc:@"2家公司"];
        }else
        {
            [cell setIcon:@"person_home_service" title:@"客户服务" desc:@""];
        }
    }else if(indexPath.section == 1)
    {
        [cell setIcon:@"person_home_setting" title:@"设置" desc:@""];
    }
    return cell;
    /*
    TCServerLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_LOG_CELL_REUSE_ID forIndexPath:indexPath];
    TCServerLog *log = [_logArray objectAtIndex:indexPath.row];
    [cell setLog:log];
    return cell;
     */
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            
        }else if(indexPath.row == 1)
        {
            TCCustomerServiceViewController *serviceVC = [TCCustomerServiceViewController new];
            [self.navigationController pushViewController:serviceVC animated:YES];
        }
    }else if(indexPath.section == 1)
    {
        
    }
}

#pragma mark - extension
- (IBAction) onProfilePage:(id)sender
{
    NSLog(@"on profile page");
}

@end
