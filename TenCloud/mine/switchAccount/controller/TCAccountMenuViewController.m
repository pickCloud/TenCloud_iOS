//
//  TCAccountMenuViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAccountMenuViewController.h"
#import "TCAccountMenuTableViewCell.h"
#import "TCListCorp+CoreDataClass.h"
#import "TCCurrentCorp.h"

#define ACCOUNT_MENU_CELL_ID    @"ACCOUNT_MENU_CELL_ID"


@interface TCAccountMenuViewController ()
@property (nonatomic, weak) IBOutlet    UIView      *darkBackgroundView;
@property (nonatomic, weak) IBOutlet    UIView      *contentView;
@property (nonatomic, weak) IBOutlet    UITableView *menuTableView;
@property (nonatomic, strong)   NSArray             *corpArray;
@property (nonatomic, assign)   CGRect              buttonRect;
- (void) dismiss;
@end

@implementation TCAccountMenuViewController

- (instancetype) initWithCorpArray:(NSArray*)corpArray buttonRect:(CGRect)rect
{
    self = [super init];
    if (self)
    {
        _corpArray = corpArray;
        _buttonRect = rect;
        _preSelectedIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.darkBackgroundView.alpha = 0.0;
    
    if (IS_iPhoneX)
    {
        //_topConstraint.constant = 40 + 20;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.darkBackgroundView addGestureRecognizer:tapGesture];

    CGRect oldRect = _menuTableView.frame;
    CGFloat newX = _buttonRect.origin.x + _buttonRect.size.width - oldRect.size.width;
    CGFloat newY = 0;
    if (IS_iPhoneX)
    {
        newY = _buttonRect.origin.y + _buttonRect.size.height + 8 + 88;
    }else
    {
        newY = _buttonRect.origin.y + _buttonRect.size.height + 8 + 64;
    }
    
    CGFloat height = _corpArray.count * 45;//TCSCALE(44);
    if (height > 10*45)
    {
        height = 10*45;
    }
    CGRect newRect = CGRectMake(newX, newY, oldRect.size.width, height);
    _menuTableView.frame = newRect;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCAccountMenuTableViewCell" bundle:nil];
    [_menuTableView registerNib:cellNib forCellReuseIdentifier:ACCOUNT_MENU_CELL_ID];
    _menuTableView.tableFooterView = [UIView new];
    _menuTableView.layer.cornerRadius = TCSCALE(6);
    _menuTableView.allowsMultipleSelection = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showContentView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - extension
- (void) dismiss
{
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:0.24 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        weakSelf.darkBackgroundView.alpha = 0.0;
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

- (void) showContentView
{
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0.01 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        weakSelf.darkBackgroundView.alpha = 1.0;
        [weakSelf.view layoutIfNeeded];
    } completion:NULL];
    
}

- (void) onTapGesture:(id)sender
{
    [self dismiss];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _corpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCListCorp *corp = [_corpArray objectAtIndex:indexPath.row];
    TCAccountMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ACCOUNT_MENU_CELL_ID forIndexPath:indexPath];
    BOOL selected = [[TCCurrentCorp shared] isSameWithID:corp.cid name:corp.company_name];
    [cell setCorp:corp];
    if (selected)
    {
        NSLog(@"cell at %@ selected",corp.company_name);
    }else
    {
        NSLog(@"cell at %@ not selected",corp.company_name);
    }
    cell.selected = selected;
    if (selected)
    {
        _preSelectedIndex = indexPath.row;
    }
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
    if (_preSelectedIndex == indexPath.row)
    {
        [self dismiss];
        return;
    }
    TCListCorp *curCorp = [_corpArray objectAtIndex:indexPath.row];
    [[TCCurrentCorp shared] setCid:curCorp.cid];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CORP_CHANGE object:nil];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    //[tableView reloadData];
    _preSelectedIndex = indexPath.row;
    
    if (_selectBlock)
    {
        _selectBlock(self,indexPath.row);
    }
    
    [self dismiss];
    
}

@end
