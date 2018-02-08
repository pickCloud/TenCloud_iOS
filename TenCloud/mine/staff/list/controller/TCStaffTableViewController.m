//
//  TCStaffTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/4.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCStaffTableViewController.h"
#import "TCStaffListRequest.h"
#import "TCStaffTableViewCell.h"
#import "TCStaffProfileViewController.h"
#import "TCJoinSettingViewController.h"
#import "FEPopupMenuController.h"
#import "TCInviteStaffViewController.h"
#import "TCChangeAdminViewController.h"
#import "TCStaffSearchRequest.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MKDropdownMenu.h"
#import "ShapeSelectView.h"
#import "ShapeView.h"
#import "TCStaff+CoreDataClass.h"
#import "TCPageManager.h"
#import "TCDataSync.h"
#define STAFF_CELL_ID       @"STAFF_CELL_ID"

@interface TCStaffTableViewController ()
<UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,MKDropdownMenuDelegate,MKDropdownMenuDataSource,TCDataSyncDelegate>
@property (nonatomic, weak) IBOutlet    UITableView     *tableView;
@property (nonatomic, weak) IBOutlet    UITextField     *keywordField;
@property (nonatomic, weak) IBOutlet    UIView          *keyboradPanel;
@property (nonatomic, weak) IBOutlet    MKDropdownMenu  *statusMenu;
@property (nonatomic, strong)   NSArray                 *statusMenuOptions;
@property (nonatomic, assign)   NSInteger               statusSelectedIndex;
@property (nonatomic, strong)   NSMutableArray          *staffArray;
@property (nonatomic, strong)   FEPopupMenuController   *menuController;
- (void) onAddButton:(id)sender;
- (void) reloadStaffArray;
- (void) doSearchWithKeyword:(NSString*)keyword withStaus:(NSInteger)status;
- (void) onShowKeyboard:(NSNotification*)notification;
- (void) onHideKeyboard:(NSNotification*)notification;
- (void) updateDropDownMenu;
- (IBAction) onCloseKeyboard:(id)sender;
@end

@implementation TCStaffTableViewController

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
    self.title = @"员工列表";
    _staffArray = [NSMutableArray new];
    
    UINib *cellNib = [UINib nibWithNibName:@"TCStaffTableViewCell" bundle:nil];
    [_tableView registerNib:cellNib forCellReuseIdentifier:STAFF_CELL_ID];
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    [self startLoading];
    [self reloadStaffArray];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(onShowKeyboard:)
                       name:UIKeyboardWillShowNotification object:nil];
    [notiCenter addObserver:self selector:@selector(onHideKeyboard:)
                       name:UIKeyboardWillHideNotification object:nil];
    
    CGRect newRect = _keyboradPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height;
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    [self.view addSubview:_keyboradPanel];
    _keyboradPanel.frame = newRect;
    
    _statusMenuOptions = [NSArray arrayWithObjects:@"全部",@"待审核",@"审核通过",@"审核不通过", nil];
    //_statusMenuOptions = [NSArray arrayWithObjects:@"全部",@"待审核",@"审核通过",@"审核拒绝", nil];
    _statusSelectedIndex = 0;
    //self.statusMenu.layer.borderColor = [[UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0] CGColor];
    //self.statusMenu.layer.borderWidth = 0.5;
    
    UIColor *selectedBackgroundColor = [UIColor colorWithRed:0.91 green:0.92 blue:0.94 alpha:1.0];
    UIColor *dropDownBgColor = [UIColor colorWithRed:39/255.0 green:42/255.0 blue:52/255.0 alpha:1.0];
    self.statusMenu.selectedComponentBackgroundColor = dropDownBgColor;
    self.statusMenu.dropdownBackgroundColor = dropDownBgColor;
    self.statusMenu.dropdownShowsTopRowSeparator = YES;
    self.statusMenu.dropdownShowsBottomRowSeparator = NO;
    self.statusMenu.dropdownShowsBorder = NO;
    self.statusMenu.backgroundDimmingOpacity = 0.5;//0.05;
    self.statusMenu.componentTextAlignment = NSTextAlignmentLeft;
    self.statusMenu.dropdownCornerRadius = TCSCALE(4.0);
    self.statusMenu.rowSeparatorColor = THEME_BACKGROUND_COLOR;
    
    UIImage *disclosureImg = [UIImage imageNamed:@"dropdown"];
    self.statusMenu.disclosureIndicatorImage = disclosureImg;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadStaffArray)
                                                 name:NOTIFICATION_REMOVE_STAFF
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadStaffArray)
                                                 name:NOTIFICATION_CHANGE_ADMIN
                                               object:nil];
    [[TCDataSync shared] addPermissionChangedObserver:self];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[TCDataSync shared] removePermissionChangedObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadStaffArray
{
    /*
    __weak  __typeof(self) weakSelf = self;
    TCStaffListRequest *req = [[TCStaffListRequest alloc] init];
    [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
        [weakSelf.staffArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.staffArray addObjectsFromArray:staffArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message) {
        
    }];
     */
    __weak  __typeof(self) weakSelf = self;
    TCStaffSearchRequest *req = [TCStaffSearchRequest new];
    //req.keyword = keyword;
    req.status = _statusSelectedIndex;
    [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
        [weakSelf.staffArray removeAllObjects];
        [weakSelf stopLoading];
        [weakSelf.staffArray addObjectsFromArray:staffArray];
        [weakSelf.tableView reloadData];
        
        //judge if current user is admin
        BOOL isAdmin = NO;
        NSInteger localUserID = [[TCLocalAccount shared] userID];
        for (TCStaff *tmpStaff in staffArray)
        {
            if (tmpStaff.is_admin && (tmpStaff.uid == localUserID))
            {
                isAdmin = YES;
                break;
            }
        }
        [[TCCurrentCorp shared] setIsAdmin:isAdmin];
        [weakSelf updateDropDownMenu];
    } failure:^(NSString *message, NSInteger errorCode) {
        BOOL isError10003 = message && [message isEqualToString:@"非公司员工"];
        if (errorCode == 10003 || isError10003) {
            [TCPageManager showPersonHomePageFromController:self];
            //[MBProgressHUD showError:@"非公司员工，自动退出公司界面" toView:nil];
        }
    }];
}

- (void) doSearchWithKeyword:(NSString*)keyword withStaus:(NSInteger)statusIndex
{
    NSInteger status = -100;
    if (_statusSelectedIndex == 1)
    {
        status = 2;
    }else if(_statusSelectedIndex == 2)
    {
        status = 3;
    }else if(_statusSelectedIndex == 3)
    {
        status = 1;
    }
    __weak __typeof(self) weakSelf = self;
    
    
    TCStaffSearchRequest *req = [TCStaffSearchRequest new];
    req.keyword = keyword;
    req.status = status;
    [req startWithSuccess:^(NSArray<TCStaff *> *staffArray) {
        [weakSelf.staffArray removeAllObjects];
        [weakSelf.staffArray addObjectsFromArray:staffArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSString *message, NSInteger errorCode) {
        
    }];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [_keywordField resignFirstResponder];
    [_statusMenu closeAllComponentsAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - extension
- (void) onAddButton:(id)sender
{
    [_keywordField resignFirstResponder];
    [_statusMenu closeAllComponentsAnimated:YES];
    
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat posY = navBarRect.origin.y + navBarRect.size.height;
    CGFloat posX = navBarRect.size.width - self.menuController.contentViewWidth - 20;
    CGPoint pos = CGPointMake(posX, posY);
    [self.menuController showInViewController:self atPosition:pos];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _staffArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCStaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STAFF_CELL_ID forIndexPath:indexPath];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    [cell setStaff:staff];
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TCStaff *staff = [_staffArray objectAtIndex:indexPath.row];
    TCStaffProfileViewController *profileVC = [[TCStaffProfileViewController alloc] initWithStaff:staff];
    [self.navigationController pushViewController:profileVC animated:YES];
}


#pragma mark - DZNEmptyDataSetSource Methods
/*
 - (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
 {
 return [UIImage imageNamed:@"no_data"];
 }
 */

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:TCFont(13.0) forKey:NSFontAttributeName];
    [attributes setObject:THEME_PLACEHOLDER_COLOR forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:@"无搜索结果" attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}


#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *word = textField.text;
    NSLog(@"word:%@ sIndex:%ld",textField.text,_statusSelectedIndex);
    [self doSearchWithKeyword:word withStaus:_statusSelectedIndex];
    [textField resignFirstResponder];
    return YES;
}


- (void) onShowKeyboard:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = CGRectGetHeight([aValue CGRectValue]);
    
    CGRect newRect = _keyboradPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height - keyboardHeight - newRect.size.height + TCSCALE(10);
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.keyboradPanel.frame = newRect;
    }];
    [_statusMenu closeAllComponentsAnimated:YES];
}


- (void) onHideKeyboard:(NSNotification*)notification
{
    CGRect newRect = _keyboradPanel.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    newRect.origin.y = screenRect.size.height;
    newRect.size.width = TCSCALE(70);
    newRect.size.height = TCSCALE(40);
    newRect.origin.x = screenRect.size.width - newRect.size.width - newRect.size.height;
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.9
                     animations:^{
                         weakSelf.keyboradPanel.frame = newRect;
                     }];
    if (_keywordField.text.length == 0)
    {
        //[self reloadStaffArray];
    }
}

- (void) updateDropDownMenu
{
    if (self.menuController)
    {
        self.menuController = nil;
    }
    __weak __typeof(self) weakSelf = self;
    FEPopupMenuItem *item1 = [[FEPopupMenuItem alloc] initWithTitle:@"设置个人加入条件" iconImage:nil action:^{
        TCJoinSettingViewController *joinVC = [TCJoinSettingViewController new];
        [weakSelf.navigationController pushViewController:joinVC animated:YES];
    }];
    item1.titleColor = THEME_TEXT_COLOR;
    FEPopupMenuItem *item2 = [[FEPopupMenuItem alloc] initWithTitle:@"邀请员工" iconImage:nil action:^{
        TCInviteStaffViewController *inviteVC = [TCInviteStaffViewController new];
        [weakSelf.navigationController pushViewController:inviteVC animated:YES];
    }];
    item2.titleColor = THEME_TEXT_COLOR;
    FEPopupMenuItem *item3 = [[FEPopupMenuItem alloc] initWithTitle:@"更换管理员" iconImage:nil action:^{
        TCChangeAdminViewController *changeVC = [TCChangeAdminViewController new];
        changeVC.staffArray = weakSelf.staffArray;
        //[changeVC.staffArray addObjectsFromArray:weakSelf.staffArray];
        NSLog(@"vc staffs:%@",changeVC.staffArray);
        [self presentViewController:changeVC animated:YES completion:^{
            
        }];
    }];
    item3.titleColor = THEME_TEXT_COLOR;
    NSMutableArray *items = [NSMutableArray new];
    TCCurrentCorp *currentCorp = [TCCurrentCorp shared];
    if ( currentCorp.isAdmin ||
         [currentCorp havePermissionForFunc:FUNC_ID_INVITE_STAFF] )
    {
        [items addObject:item1];
        [items addObject:item2];
    }
    if (currentCorp.isAdmin)
    {
        [items addObject:item3];
    }
    if (items.count > 0)
    {
        UIImage *addServerImg = [UIImage imageNamed:@"navbar_add"];
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:addServerImg forState:UIControlStateNormal];
        [addButton sizeToFit];
        [addButton addTarget:self action:@selector(onAddButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        self.navigationItem.rightBarButtonItem = addItem;
        
        self.menuController = [[FEPopupMenuController alloc] initWithItems:items];
        self.menuController.isShowArrow = NO;
        self.menuController.contentViewWidth = 180;
        self.menuController.contentViewBackgroundColor = THEME_NAVBAR_TITLE_COLOR;
        self.menuController.itemSeparatorLineColor = TABLE_CELL_BG_COLOR;
        self.menuController.contentViewCornerRadius = TCSCALE(4.0);
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction) onCloseKeyboard:(id)sender
{
    [_keywordField resignFirstResponder];
}


#pragma mark - MKDropdownMenuDataSource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return _statusMenuOptions.count;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    //return 0; // use default row height
    return TCSCALE(32);
}

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu widthForComponent:(NSInteger)component {
    return MAX(dropdownMenu.bounds.size.width/3, 125);
    //return 0; // use automatic width
}

- (BOOL)dropdownMenu:(MKDropdownMenu *)dropdownMenu shouldUseFullRowWidthForComponent:(NSInteger)component {
    return NO;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:self.statusMenuOptions[_statusSelectedIndex]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCSCALE(12) weight:UIFontWeightLight],
                                                        NSForegroundColorAttributeName: THEME_PLACEHOLDER_COLOR}];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component {
    NSLog(@"statusMenuOptions:%@",self.statusMenuOptions);
    for (NSString *opt in self.statusMenuOptions)
    {
        NSLog(@"opt:%@",opt);
    }
    NSLog(@"seelI:%ld",_statusSelectedIndex);
    return [[NSAttributedString alloc] initWithString:self.statusMenuOptions[_statusSelectedIndex]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCSCALE(12) weight:UIFontWeightRegular],
                                                        NSForegroundColorAttributeName: THEME_TEXT_COLOR}];
    
}

- (UIView *)dropdownMenu:(MKDropdownMenu *)dropdownMenu viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    ShapeSelectView *shapeSelectView = (ShapeSelectView *)view;
    if (shapeSelectView == nil || ![shapeSelectView isKindOfClass:[ShapeSelectView class]]) {
        shapeSelectView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ShapeSelectView class]) owner:nil options:nil] firstObject];
    }
    //shapeSelectView.shapeView.sidesCount = row + 2;
    NSString *statusStr = self.statusMenuOptions[row];
    shapeSelectView.textLabel.text = statusStr;//self.statusMenuOptions[row];
    shapeSelectView.selected = _statusSelectedIndex == row;
    /*
    if ([statusStr isEqualToString:@"审核通过"])
    {
        shapeSelectView.selected = YES;
    }else
    {
        shapeSelectView.selected = NO;
    }
     */
    //shapeSelectView.selected = 0;
    return shapeSelectView;
    /*
    switch (component) {
        case DropdownComponentShape: {

        }
        case 2: {
            LineWidthSelectView *lineWidthSelectView = (LineWidthSelectView *)view;
            if (lineWidthSelectView == nil || ![lineWidthSelectView isKindOfClass:[LineWidthSelectView class]]) {
                lineWidthSelectView = [LineWidthSelectView new];
                lineWidthSelectView.backgroundColor = [UIColor clearColor];
            }
            lineWidthSelectView.lineColor = self.view.tintColor;
            lineWidthSelectView.lineWidth = row * 2 + 1;
            return lineWidthSelectView;
        }
        default:
            return nil;
    }
     */
}

- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self colorForRow:row];
    /*
    if (component == DropdownComponentColor) {
        
    }
    return nil;
     */
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //self.shapeView.sidesCount = row + 2;
    [_keywordField resignFirstResponder];
    _statusSelectedIndex = row;
    [dropdownMenu reloadComponent:component];
    [dropdownMenu closeAllComponentsAnimated:YES];
    [self doSearchWithKeyword:_keywordField.text withStaus:_statusSelectedIndex];
    /*
    switch (component) {
        case DropdownComponentShape:

            break;
        case DropdownComponentColor:
            self.shapeView.fillColor = [self colorForRow:row];
            break;
        case DropdownComponentLineWidth:
            self.shapeView.lineWidth = row * 2 + 1;
            break;
        default:
            break;
    }
     */
}

- (UIColor *)colorForRow:(NSInteger)row {
    return DROPDOWN_CELL_BG_COLOR;
    /*
    return [UIColor colorWithHue:(CGFloat)row/[self.statusMenuOptions numberOfRowsInComponent:0]
                      saturation:1.0
                      brightness:1.0
                           alpha:1.0];
     */
}

#pragma mark - TCDataSyncDelegate
/*
- (void) dataSync:(TCDataSync*)sync adminChanged:(BOOL)changed
{
    [self reloadStaffArray];
}
*/
- (void) dataSync:(TCDataSync*)sync permissionChanged:(NSInteger)changed
{
    NSLog(@"receive sync perm changed");
    [self reloadStaffArray];
}

@end
