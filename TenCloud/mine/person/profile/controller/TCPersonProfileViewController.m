//
//  TCPersonProfileViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCPersonProfileViewController.h"
#import "TCEditTextTableViewCell.h"
#define PROFILE_CELL_EDIT_TEXT      @"PROFILE_CELL_EDIT_TEXT"
#define PROFILE_CELL_EDIT_AVATAR    @"PROFILE_CELL_EDIT_AVATAR"
#define PROFILE_CELL_EDIT_GENDAR    @"PROFILE_CELL_EDIT_GENDAR"
#define PROFILE_CELL_EDIT_DATE      @"PROFILE_CELL_EDIT_DATE"

@interface TCPersonProfileViewController ()
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *cellItemArray;
@end

@implementation TCPersonProfileViewController

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
    self.title = @"个人资料";
    
    _cellItemArray = [NSMutableArray new];
    TCEditCellData *data1 = [TCEditCellData new];
    data1.title = @"姓名";
    data1.editPageTitle = @"修改姓名";
    data1.initialValue = [[TCLocalAccount shared] name];
    [_cellItemArray addObject:data1];
    
    UINib *textCellNib = [UINib nibWithNibName:@"TCEditTextTableViewCell" bundle:nil];
    [self.tableView registerNib:textCellNib forCellReuseIdentifier:PROFILE_CELL_EDIT_TEXT];
    
    self.tableView.tableFooterView = [UIView new];
    
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
    TCEditTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PROFILE_CELL_EDIT_TEXT forIndexPath:indexPath];
    cell.fatherViewController = self;
    TCEditCellData *data = [_cellItemArray objectAtIndex:indexPath.row];
    cell.data = data;
    cell.valueChangedBlock = ^(TCEditTableViewCell *cell, NSInteger selectedIndex, id newValue) {
        
    };
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
