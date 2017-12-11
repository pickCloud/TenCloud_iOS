//
//  TCServerHomeViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/6.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerHomeViewController.h"
#import "TCClusterRequest.h"
#import "TCServerTableViewCell.h"
#define SERVER_CELL_REUSE_ID    @"SERVER_CELL_REUSE_ID"

@interface TCServerHomeViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *serverArray;
@end

@implementation TCServerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务器";
    _serverArray = [NSMutableArray new];
    
    /*
    TCPasswordLoginRequest *loginReq = [[TCPasswordLoginRequest alloc] initWithPhoneNumber:@"18521316580" password:@"111111"];
    [loginReq startWithSuccess:^(NSString *token) {
        NSLog(@"登录成功:%@",token);
    } failure:^(NSString *message) {
        NSLog(@"fail:%@",message);
    }];
     */
    UINib *serverCellNib = [UINib nibWithNibName:@"TCServerTableViewCell" bundle:nil];
    [_tableView registerNib:serverCellNib forCellReuseIdentifier:SERVER_CELL_REUSE_ID];
    
    __weak  __typeof(self)  weakSelf = self;
    TCClusterRequest *request = [[TCClusterRequest alloc] init];
    [request startWithSuccess:^(NSArray<TCServer *> *serverArray) {
        //NSLog(@"severArray:%@",serverArray);
        [weakSelf.serverArray removeAllObjects];
        [weakSelf.serverArray addObjectsFromArray:serverArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        //NSLog(@"msg:%@",message);
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
    return _serverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SERVER_CELL_REUSE_ID forIndexPath:indexPath];
    TCServer *server = [_serverArray objectAtIndex:indexPath.row];
    [cell setServer:server];
    return cell;
    /*
    YETeacherSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_RESULT_TABLE_CELL_REUSE_ID forIndexPath:indexPath];
    Teacher *teacher = [_teacherArray objectAtIndex:indexPath.row];
    [cell setTeacher:teacher];
    return cell;
     */
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    Teacher *teacher = [_teacherArray objectAtIndex:indexPath.row];
    YETeacherResumeViewController *profileVC = [[YETeacherResumeViewController alloc] initWithTID:teacher.uid];
    [self.navigationController pushViewController:profileVC animated:YES];
     */
}

@end
