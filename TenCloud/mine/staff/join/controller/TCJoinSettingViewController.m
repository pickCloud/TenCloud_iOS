//
//  TCJoinSettingViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/9.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCJoinSettingViewController.h"
#import "TCJoinSettingRequest.h"
#import "TCJoinSettingItem.h"
#import "TCJoinSettingTableViewCell.h"
#import "TCSetJoinSettingRequest.h"
#define JOIN_SETTING_CELL_ID    @"JOIN_SETTING_CELL_ID"

@interface TCJoinSettingViewController ()
@property (nonatomic, strong)   NSDictionary    *itemDict;
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, strong)   NSMutableArray          *keyArray;
@property (nonatomic, strong)   NSMutableArray          *selectedKeyArray;
- (void) onConfirmButton:(id)sender;
@end

@implementation TCJoinSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置加入条件";
    
    UIButton *msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    msgButton.titleLabel.font = TCBoldFont(14.0);
    [msgButton setTitle:@"确定" forState:UIControlStateNormal];
    [msgButton setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
    [msgButton sizeToFit];
    [msgButton addTarget:self action:@selector(onConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:msgButton];
    self.navigationItem.rightBarButtonItem = messageItem;
    
    _keyArray = [NSMutableArray new];
    [_keyArray addObject:@"name"];
    [_keyArray addObject:@"mobile"];
    [_keyArray addObject:@"id_card"];
    _selectedKeyArray = [NSMutableArray new];
    TCJoinSettingItem *item1 = [TCJoinSettingItem new];
    item1.name = @"姓名";
    item1.key = @"name";
    item1.required = YES;
    TCJoinSettingItem *item2 = [TCJoinSettingItem new];
    item2.name = @"手机";
    item2.key = @"mobile";
    item2.required = YES;
    TCJoinSettingItem *item3 = [TCJoinSettingItem new];
    item3.name = @"身份证号码";
    item3.key = @"id_card";
    item3.required = NO;
    _itemDict = [NSDictionary dictionaryWithObjectsAndKeys:item1,@"name",
                 item2,@"mobile",
                 item3,@"id_card",nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"TCJoinSettingTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:JOIN_SETTING_CELL_ID];
    _tableView.allowsMultipleSelection = YES;
    _tableView.tableFooterView = [UIView new];
    
    [self startLoading];
    __weak __typeof(self) weakSelf = self;
    TCJoinSettingRequest *req = [TCJoinSettingRequest new];
    [req startWithSuccess:^(NSArray<NSString *> *settingArray) {
        [weakSelf stopLoading];
        [weakSelf.selectedKeyArray removeAllObjects];
        [weakSelf.selectedKeyArray addObjectsFromArray:settingArray];
        [weakSelf.tableView reloadData];
        
        for (int i = 0; i < settingArray.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [weakSelf.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    } failure:^(NSString *message) {
        
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
    return _keyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCJoinSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JOIN_SETTING_CELL_ID forIndexPath:indexPath];
    NSString *keyName = [_keyArray objectAtIndex:indexPath.row];
    TCJoinSettingItem *item = [_itemDict objectForKey:keyName];
    [cell setItem:item];
    BOOL selected = [_selectedKeyArray containsObject:keyName];
    [cell setSelected:selected animated:NO];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyName = [_keyArray objectAtIndex:indexPath.row];
    TCJoinSettingItem *item = [_itemDict objectForKey:keyName];
    if (item.required)
    {
        [MBProgressHUD showError:@"必选项，不能修改" toView:nil];
    }
}

#pragma mark - extension
- (void) onConfirmButton:(id)sender
{
    NSArray *paths = [_tableView indexPathsForSelectedRows];
    NSMutableArray *selectedKeyArray = [NSMutableArray new];
    for (NSIndexPath *path in paths)
    {
        NSString *selectedKey = [_keyArray objectAtIndex:path.row];
        [selectedKeyArray addObject:selectedKey];
    }
    NSString *selectedKeyStr = [selectedKeyArray componentsJoinedByString:@","];
    __weak __typeof(self) weakSelf = self;
    TCSetJoinSettingRequest *req = [TCSetJoinSettingRequest new];
    req.setting = selectedKeyStr;
    [req startWithSuccess:^(NSString *message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGE_JOIN_SETTING
                                                            object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *message) {
        [MBProgressHUD showError:message toView:nil];
    }];
}
@end
