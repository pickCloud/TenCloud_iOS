//
//  TCPermissionViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/1/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCPermissionViewController.h"
#import "TCPermissionTableViewController.h"
#import "TCPermissionNode+CoreDataClass.h"
#import "TCEditingPermission.h"
#import <VTMagic/VTMagic.h>
#import "TCModifyPermissionRequest.h"
#import "TCModifyUserPermissionRequest.h"
#import "TCTemplate+CoreDataClass.h"
#import "TCDataPermissionViewController.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "TCPermissionTemplateCell.h"
#import "TCTemplateListRequest.h"

#define PERMISSION_TEMPLATE_CELL_ID @"PERMISSION_TEMPLATE_CELL_ID"

@interface TCPermissionViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong)   VTMagicController           *magicController;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topHeightConstraint;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *templatePanelHeightConstraint;
@property (nonatomic, weak) IBOutlet    UILabel             *titleLabel;
@property (nonatomic, weak) IBOutlet    UIButton            *confirmButton;
@property (nonatomic, weak) IBOutlet    UICollectionView    *templateCollectionView;
@property (nonatomic, strong)   NSMutableArray              *templateArray;
- (IBAction) onCloseButton:(id)sender;
- (IBAction) onConfirmButton:(id)sender;
@end

@implementation TCPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _templateArray = [NSMutableArray new];
    
    if (IS_iPhoneX)
    {
        _topHeightConstraint.constant = 64+27;
    }
    
    if (_state == PermissionVCStateNew)
    {
        self.titleLabel.text = @"模版权限选择";
    }else if(_state == PermissionVCPreviewPermission)
    {
        self.titleLabel.text = @"查看权限";
        [self.confirmButton setHidden:YES];
    }else
    {
        if (_userID > 0)
        {
            self.titleLabel.text = @"设置权限";
        }else
        {
            self.titleLabel.text = @"修改模版权限";
        }
    }
    
    UINib *templateCellNib = [UINib nibWithNibName:@"TCPermissionTemplateCell" bundle:nil];
    [_templateCollectionView registerNib:templateCellNib forCellWithReuseIdentifier:PERMISSION_TEMPLATE_CELL_ID];
    JYEqualCellSpaceFlowLayout *areaLayout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:12.0];
    areaLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_templateCollectionView setCollectionViewLayout:areaLayout];
    
    if (_state == PermissionVCModifyUserPermission)
    {
        _templatePanelHeightConstraint.constant = 44;
        [self startLoading];
        __weak __typeof(self) weakSelf = self;
        TCTemplateListRequest *request = [[TCTemplateListRequest alloc] init];
        [request startWithSuccess:^(NSArray<TCTemplate *> *templateArray) {
            [weakSelf.templateArray removeAllObjects];
            [weakSelf stopLoading];
            [weakSelf.templateArray addObjectsFromArray:templateArray];
            [weakSelf.templateCollectionView reloadData];
        } failure:^(NSString *message) {
            [MBProgressHUD showError:message toView:nil];
            [self stopLoading];
        }];
    }else
    {
        _templatePanelHeightConstraint.constant = 0;
    }
    
    [self addChildViewController:self.magicController];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat rectY = _topHeightConstraint.constant + _templatePanelHeightConstraint.constant;
    CGFloat rectH = screenRect.size.height - rectY;
    CGRect rect = CGRectMake(0, rectY, screenRect.size.width, rectH);
    _magicController.view.frame = rect;
    _magicController.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_magicController.view];
    [_magicController.magicView reloadData];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - extension
- (IBAction) onCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) onConfirmButton:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    TCEditingPermission *perm = [TCEditingPermission shared];
    if (_state == PermissionVCStateEdit)
    {
        [MMProgressHUD showWithStatus:@"修改权限中"];
        TCModifyPermissionRequest *req = [TCModifyPermissionRequest new];
        req.templateID = (NSInteger)_tmpl.tid;
        req.name = _tmpl.name;
        req.funcPermissionArray = perm.permissionIDArray;
        req.projectPermissionArray = perm.projectPermissionIDArray;
        req.filePermissionArray = perm.filePermissionIDArray;
        req.serverPermissionArray = perm.serverPermissionIDArray;
        [req startWithSuccess:^(NSString *message) {
            if (weakSelf.modifiedBlock)
            {
                weakSelf.modifiedBlock(weakSelf);
            }
            [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *message) {
            [MMProgressHUD dismissWithError:message afterDelay:1.32];
        }];
        return;
    }else if(_state == PermissionVCModifyUserPermission)
    {
        [MMProgressHUD showWithStatus:@"修改权限中"];
        TCModifyUserPermissionRequest *req = [TCModifyUserPermissionRequest new];
        req.userID = _userID;
        req.funcPermissionArray = perm.permissionIDArray;
        req.projectPermissionArray = perm.projectPermissionIDArray;
        req.filePermissionArray = perm.filePermissionIDArray;
        req.serverPermissionArray = perm.serverPermissionIDArray;
        [req startWithSuccess:^(NSString *message) {
            if (weakSelf.modifiedBlock)
            {
                weakSelf.modifiedBlock(weakSelf);
            }
            [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSString *message) {
            [MMProgressHUD dismissWithError:message afterDelay:1.32];
        }];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (VTMagicController *)magicController
{
    if (!_magicController)
    {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.itemScale = 1.0;
        _magicController.magicView.headerHeight = 0;
        _magicController.magicView.navigationHeight = 40;//TCSCALE(44);
        
        _magicController.magicView.itemSpacing = TCSCALE(29.5);
        _magicController.magicView.bounces = YES;
        _magicController.magicView.headerView.backgroundColor = THEME_TINT_COLOR;
        _magicController.magicView.sliderColor = THEME_TINT_COLOR;
        _magicController.magicView.navigationColor = TABLE_CELL_BG_COLOR;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.separatorHeight = 0.0f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat sliderWidth = screenRect.size.width * 0.26666;
        _magicController.magicView.sliderWidth = sliderWidth;
    }
    return _magicController;
}



#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
    TCEditingPermission *editingPermission = [TCEditingPermission shared];
    NSArray *nodeArray = editingPermission.permissionArray;
    for (TCPermissionNode *node in nodeArray)
    {
        [titleList addObject:node.name];
    }
    return titleList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        UIColor *normalColor = [UIColor colorWithRed:137/255.0 green:154/255.0 blue:182/255.0 alpha:1.0];
        [menuItem setTitleColor:normalColor forState:UIControlStateNormal];
        [menuItem setTitleColor:THEME_TINT_COLOR forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    UIViewController *controller = nil;
    NSLog(@"page index:%ld",pageIndex);
    TCPermissionNode *node = [[[TCEditingPermission shared] permissionArray] objectAtIndex:pageIndex];
    if (pageIndex == 0)
    {
        controller = [[TCPermissionTableViewController alloc] initWithPermissionNode:node state:_state];
    }else
    {
        controller = [[TCDataPermissionViewController alloc] initWithPermissionNode:node state:_state];
    }
    return controller;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    //    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    //    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}


#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _templateArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCPermissionTemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PERMISSION_TEMPLATE_CELL_ID forIndexPath:indexPath];
    //NSString *name = [_templateArray objectAtIndex:indexPath.row];
    TCTemplate *template = [_templateArray objectAtIndex:indexPath.row];
    [cell setName:template.name];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCTemplate *template = [_templateArray objectAtIndex:indexPath.row];
    NSString *text = template.name;
    if (text == nil || text.length == 0)
    {
        text = @"默认";
    }
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TCFont(12.0)} context:nil].size;
    return CGSizeMake(textSize.width + 24, textSize.height + 18);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"item selected:%ld",indexPath.row);
    if (indexPath.row <= _templateArray.count)
    {
        TCTemplate *selectedTmpl = [_templateArray objectAtIndex:indexPath.row];
        [[TCEditingPermission shared] reset];
        [[TCEditingPermission shared] setTemplate:selectedTmpl];
        [_magicController.magicView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
