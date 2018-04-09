//
//  SBAProviderViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/4/8.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "SBAProviderViewController.h"
#import "TCCloudListRequest.h"
#import "TCCloud+CoreDataClass.h"
#import "SBAProviderTableViewCell.h"
#import "SBAAccessKeyViewController.h"
#define SBA_PROVIDER_CELL_ID    @"SBA_PROVIDER_CELL_ID"

@interface SBAProviderViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   UIButton                *nextButton;
@property (nonatomic, strong)   NSMutableArray          *cloudArray;
- (void) onNextButton:(UIButton*)button;
@end

@implementation SBAProviderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"批量添加云主机";
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    _cloudArray = [NSMutableArray new];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(onNextButton:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.titleLabel.font = TCFont(16);
    [_nextButton sizeToFit];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_nextButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    TCCloud *cloud0 = [TCCloud MR_createEntity];
    cloud0.cloudID = 1;
    cloud0.name = @"阿里云";
    cloud0.icon = @"cloud_aliyun";
    [_cloudArray addObject:cloud0];
    
    TCCloud *cloud2 = [TCCloud MR_createEntity];
    cloud2.cloudID = 2;
    cloud2.name = @"腾讯云";
    cloud2.icon = @"cloud_tencent";
    [_cloudArray addObject:cloud2];
    
    TCCloud *cloud3 = [TCCloud MR_createEntity];
    cloud3.cloudID = 3;
    cloud3.name = @"微软云";
    cloud3.icon = @"cloud_micro";
    [_cloudArray addObject:cloud3];
    
    TCCloud *cloud4 = [TCCloud MR_createEntity];
    cloud4.cloudID = 4;
    cloud4.name = @"亚马逊云";
    cloud4.icon = @"cloud_amazon";
    [_cloudArray addObject:cloud4];
    
    UINib *cellNib = [UINib nibWithNibName:@"SBAProviderTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:SBA_PROVIDER_CELL_ID];
    
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
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *path0 = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView selectRowAtIndexPath:path0 animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
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
    return _cloudArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBAProviderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SBA_PROVIDER_CELL_ID forIndexPath:indexPath];
    TCCloud *cloud = [_cloudArray objectAtIndex:indexPath.row];
    [cell setCloud:cloud];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - extension
- (void) onNextButton:(UIButton*)button
{
    SBAAccessKeyViewController *accessVC = [SBAAccessKeyViewController new];
    [self.navigationController pushViewController:accessVC animated:YES];
}
@end
