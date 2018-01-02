//
//  TCTemplateTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCTemplateTableViewController.h"
#import "TCTemplateTableViewCell.h"
#import "TCCurrentCorp.h"
#import "TCTemplateListRequest.h"
#import "TCAddTemplateViewController.h"

#define TEMPLATE_CELL_REUSE_ID      @"TEMPLATE_CELL_REUSE_ID"

@interface TCTemplateTableViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *templateArray;
- (void) onAddTemplateButton:(id)sender;
- (void) reloadTemplateArray;
@end

@implementation TCTemplateTableViewController

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
    self.title = @"权限模版管理";
    _templateArray = [NSMutableArray new];
    
    UIImage *addTmplImg = [UIImage imageNamed:@"template_add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addTmplImg forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddTemplateButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCTemplateTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:TEMPLATE_CELL_REUSE_ID];
    _tableView.tableFooterView = [UIView new];
    
    [self startLoading];
    [self reloadTemplateArray];
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
    return _templateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEMPLATE_CELL_REUSE_ID forIndexPath:indexPath];
    TCTemplate *template = [_templateArray objectAtIndex:indexPath.row];
    [cell setTemplate:template];
    /*
    TCMyCorpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_CORP_CELL_REUSE_ID forIndexPath:indexPath];
    TCCorp *corp = [_corpArray objectAtIndex:indexPath.row];
    [cell setCorp:corp];
     */
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


#pragma mark - extension
- (void) onAddTemplateButton:(id)sender
{
    TCAddTemplateViewController *addVC = [TCAddTemplateViewController new];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void) reloadTemplateArray
{
    __weak __typeof(self) weakSelf = self;
    NSInteger cid = [[TCCurrentCorp shared] cid];
    TCTemplateListRequest *request = [[TCTemplateListRequest alloc] initWithCorpID:cid];
    [request startWithSuccess:^(NSArray<TCTemplate *> *templateArray) {
        [weakSelf.templateArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.templateArray addObjectsFromArray:templateArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
}

@end
