//
//  TCAppBindRepoViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/4/3.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAppBindRepoViewController.h"
#import "TCBindRepoTableViewCell.h"
#import "TCGithubReposRequest.h"
#import "GithubLoginViewController.h"
#define BIND_REPO_CELL_ID       @"BIND_REPO_CELL_ID"

@interface TCAppBindRepoViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   UIButton                *confirmButton;
@property (nonatomic, strong)   NSMutableArray          *repoArray;
- (void) onConfirmButton:(UIButton*)button;
- (void) reloadRepoArray;
@end

@implementation TCAppBindRepoViewController

- (id) init
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
    _repoArray = [NSMutableArray new];
    self.title = @"绑定github代码仓库";
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.titleLabel.font = TCFont(16);
    [_confirmButton sizeToFit];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_confirmButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCBindRepoTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:BIND_REPO_CELL_ID];

    [self startLoading];
    [self reloadRepoArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadRepoArray) name:NOTI_GITHUB_LOGIN_SUCCESS object:nil];

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
    return _repoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCBindRepoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BIND_REPO_CELL_ID forIndexPath:indexPath];
    TCAppRepo *repo = [_repoArray objectAtIndex:indexPath.row];
    [cell setRepo:repo];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - extension
- (void) onConfirmButton:(UIButton*)button
{
    if (_bindBlock)
    {
        NSArray *rows = self.tableView.indexPathsForSelectedRows;
        if (rows && rows.count > 0)
        {
            NSIndexPath *path = rows.firstObject;
            TCAppRepo *repo = [_repoArray objectAtIndex:path.row];
            _bindBlock(repo);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) reloadRepoArray
{
    __weak __typeof(self) weakSelf = self;
    TCGithubReposRequest *req = [TCGithubReposRequest new];
    req.url = SERVER_URL_STRING;
    [req startWithSuccess:^(NSArray<TCAppRepo *> *repoArray) {
        [weakSelf.repoArray addObjectsFromArray:repoArray];
        [weakSelf.tableView reloadData];
        [weakSelf stopLoading];
    } failure:^(NSString *message, NSString *urlStr) {
        if (urlStr && urlStr.length > 0)
        {
            GithubLoginViewController *vc = [GithubLoginViewController new];
            vc.loginURLString = urlStr;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else
        {
            [MBProgressHUD showError:message toView:nil];
        }
        [weakSelf stopLoading];
    }];
}
@end
