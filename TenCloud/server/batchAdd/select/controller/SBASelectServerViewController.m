//
//  SBASelectServerViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/4/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBASelectServerViewController.h"
#import "SBASelectServerTableViewCell.h"
#import "TCAddingServer+CoreDataClass.h"
#import "SBAAddingView.h"
#import "UIView+TCAlertView.h"
#import "SBASuccessView.h"
#import "SBAFailView.h"
#define SBA_SELECT_CELL_ID    @"SBA_SELECT_CELL_ID"

@interface SBASelectServerViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   UIButton                *nextButton;
@property (nonatomic, strong)   NSMutableArray          *serverArray;
@property (nonatomic, strong)   SBAAddingView           *addingView;
@property (nonatomic, strong)   SBASuccessView          *successView;
@property (nonatomic, strong)   SBAFailView             *failView;
- (void) onImportButton:(UIButton*)button;

//for fake data
@property (nonatomic, assign)   NSInteger   addingTimes;
- (void) onAddingTimer;
@end

@implementation SBASelectServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"批量添加云主机";
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    _serverArray = [NSMutableArray new];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"导入" forState:UIControlStateNormal];
    [_nextButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(onImportButton:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.titleLabel.font = TCFont(16);
    [_nextButton sizeToFit];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_nextButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    TCAddingServer *server0 = [TCAddingServer MR_createEntity];
    server0.is_add = 0;
    server0.instance_id = @"A_Win2008_HNIS";
    server0.public_ip = @"123.123.123.123";
    server0.inner_ip = @"192.168.0.1";
    server0.net_type = @"经典云";
    server0.region_id = @"华南1";
    [_serverArray addObject:server0];
    
    TCAddingServer *server1 = [TCAddingServer MR_createEntity];
    server1.is_add = 1;
    server1.instance_id = @"A_Win2008_H124";
    server1.public_ip = @"124.124.124.124";
    server1.inner_ip = @"192.168.0.2";
    server1.net_type = @"经典云";
    server1.region_id = @"华南2";
    [_serverArray addObject:server1];
    
    TCAddingServer *server2 = [TCAddingServer MR_createEntity];
    server2.is_add = 0;
    server2.instance_id = @"A_Win2008_H125";
    server2.public_ip = @"125.125.125.125";
    server2.inner_ip = @"192.168.0.3";
    server2.net_type = @"经典云";
    server2.region_id = @"华南3";
    [_serverArray addObject:server2];
    
    UINib *cellNib = [UINib nibWithNibName:@"SBASelectServerTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:SBA_SELECT_CELL_ID];
    
    _addingView = [SBAAddingView createViewFromNib];
    _successView = [SBASuccessView createViewFromNib];
    _failView = [SBAFailView createViewFromNib];
    /*
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCCloudListRequest *req = [TCCloudListRequest new];
    [req startWithSuccess:^(NSArray<TCCloud *> *cloudArray) {
        [weakSelf.cloudArray addObjectsFromArray:cloudArray];
        NSLog(@"clous:%@",weakSelf.cloudArray);
        [weakSelf stopLoading];
    } failure:^(NSString *message) {
        [weakSelf stopLoading];
    }];
    */
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSIndexPath *path0 = [NSIndexPath indexPathForRow:0 inSection:0];
    //[_tableView selectRowAtIndexPath:path0 animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
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
    SBASelectServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SBA_SELECT_CELL_ID forIndexPath:indexPath];
    TCAddingServer *server = [_serverArray objectAtIndex:indexPath.row];
    [cell setServer:server];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - extension
- (void) onImportButton:(UIButton*)button
{
    NSArray *allPaths = [_tableView indexPathsForSelectedRows];
    NSMutableArray *paths = [NSMutableArray new];
    for (NSIndexPath *path in allPaths)
    {
        TCAddingServer *server = [_serverArray objectAtIndex:path.row];
        if (!server.is_add)
        {
            [paths addObject:path];
        }
    }
    
    if (paths.count == 0)
    {
        [MBProgressHUD showError:@"请选择服务器" toView:nil];
        return;
    }
    
    //send import request
    [_addingView setProgress:0 total:5 success:0 fail:0];
    TCAlertController *vc = [TCAlertController alertControllerWithAlertView:_addingView];
    [vc present];
    
    //for fake data
    _addingTimes = 0;
    [self onAddingTimer];
}

- (void) onAddingTimer
{
    if (_addingTimes < 6)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.2 target:self
                                       selector:@selector(onAddingTimer)
                                       userInfo:nil
                                        repeats:NO];
        [_addingView setProgress:0.2*_addingTimes
                           total:5 success:_addingTimes+1
                            fail:0];
        _addingTimes ++;
    }else
    {
        [_addingView hideView];
        /*
        //导入成功页面
        _successView.importServerAmount = 5;
        __weak __typeof(self) weakSelf = self;
        _successView.successBlock = ^(SBASuccessView *view) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        TCAlertController *vc = [TCAlertController alertControllerWithAlertView:_successView];
        [vc present];
         */
        [_failView setTotalAmount:5 success:4 fail:1];
        __weak __typeof(self) weakSelf = self;
        _failView.cancelBlock = ^(SBAFailView *view) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _failView.retryBlock = ^(SBAFailView *view) {
            
        };
        TCAlertController *vc = [TCAlertController alertControllerWithAlertView:_failView];
        [vc present];
    }
}
@end
