//
//  TCSearchFilterViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCSearchFilterViewController.h"
#import "TCSearchFilterCollectionCell.h"
#import "TCClusterProvider+CoreDataClass.h"
#import "JYEqualCellSpaceFlowLayout.h"

#define SEARCH_FILTER_CELL_REUSE_ID     @"SEARCH_FILTER_CELL_REUSE_ID"

@interface TCSearchFilterViewController ()
@property (nonatomic, weak) IBOutlet    UIView      *darkBackgroundView;
@property (nonatomic, weak) IBOutlet    UIView      *contentView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *contentViewTrailingConstraint;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UICollectionView    *providerView;
@property (nonatomic, weak) IBOutlet    UICollectionView    *areaView;
@property (nonatomic, strong)   NSArray                     *providerArray;
- (IBAction) onConfirmButton:(id)sender;
- (void) dismiss;
@end

@implementation TCSearchFilterViewController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (instancetype) initWithProviderArray:(NSArray*)providerArray
{
    self = [super init];
    if (self)
    {
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _providerArray = providerArray;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.darkBackgroundView.alpha = 0.0;
    self.contentViewTrailingConstraint.constant = - kScreenWidth;
    
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 40 + 20;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.darkBackgroundView addGestureRecognizer:tapGesture];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.darkBackgroundView addGestureRecognizer:swipeGesture];
    
    UINib *cellNib = [UINib nibWithNibName:@"TCSearchFilterCollectionCell" bundle:nil];
    [_providerView registerNib:cellNib forCellWithReuseIdentifier:SEARCH_FILTER_CELL_REUSE_ID];
    JYEqualCellSpaceFlowLayout *layout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:12.0];
    [_providerView setCollectionViewLayout:layout];
    
    [_areaView registerNib:cellNib forCellWithReuseIdentifier:SEARCH_FILTER_CELL_REUSE_ID];
    JYEqualCellSpaceFlowLayout *areaLayout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:12.0];
    [_areaView setCollectionViewLayout:areaLayout];
    [_areaView setAllowsMultipleSelection:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - extension
- (IBAction) onConfirmButton:(id)sender
{
    NSLog(@"on confirm button");
    
    NSArray *selectedProviderPaths = [_providerView indexPathsForSelectedItems];
    if (selectedProviderPaths.count == 0)
    {
        [MBProgressHUD showError:@"请选择服务商" toView:nil];
        return;
    }
    
    NSArray *selectedAreaPaths = [_areaView indexPathsForSelectedItems];
    /*
    if (selectedAreaPaths.count == 0)
    {
        [MBProgressHUD showError:@"请选择区域" toView:nil];
        return;
    }
     */
    
    [self dismiss];
    
    NSMutableArray *providers = [NSMutableArray new];
    NSIndexPath *providerPath = selectedProviderPaths.firstObject;
    TCClusterProvider *provider = [_providerArray objectAtIndex:providerPath.row];
    [providers addObject:provider.provider];
    
    NSMutableArray *areas = [NSMutableArray new];
    for (int i = 0; i < selectedAreaPaths.count; i++)
    {
        NSIndexPath *areaPath = [selectedAreaPaths objectAtIndex:i];
        NSString *region = [provider.regions objectAtIndex:areaPath.row];
        [areas addObject:region];
    }
    
    NSDictionary *filterDict = @{@"provider":providers,
                                 @"region":areas
                                 };
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DO_SEARCH object:filterDict];
}

- (void) dismiss
{
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        weakSelf.contentViewTrailingConstraint.constant = -_contentView.frame.size.width;
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
    self.contentViewTrailingConstraint.constant = - _contentView.frame.size.width;
    
    __weak __typeof(self) weakSelf = self;
    [self.view layoutIfNeeded];
    [UIView animateKeyframesWithDuration:POPUP_TIME delay:0.01 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        weakSelf.darkBackgroundView.alpha = 1.0;
        
        weakSelf.contentViewTrailingConstraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
    } completion:NULL];
    
}

- (void) onTapGesture:(id)sender
{
    [self dismiss];
}


#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _providerView)
    {
        return _providerArray.count;
    }else if(collectionView == _areaView)
    {
        NSArray *itemArray = [_providerView indexPathsForSelectedItems];
        if (itemArray && itemArray.count > 0)
        {
            NSIndexPath *selectedPath = itemArray.firstObject;
            TCClusterProvider *provider = [_providerArray objectAtIndex:selectedPath.row];
            return provider.regions.count;
        }
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _providerView)
    {
        TCSearchFilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SEARCH_FILTER_CELL_REUSE_ID forIndexPath:indexPath];
        TCClusterProvider *provider = [_providerArray objectAtIndex:indexPath.row];
        [cell setName:provider.provider];
        return cell;
    }else if(collectionView == _areaView)
    {
        TCSearchFilterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SEARCH_FILTER_CELL_REUSE_ID forIndexPath:indexPath];
        NSArray *itemArray = [_providerView indexPathsForSelectedItems];
        if (itemArray && itemArray.count > 0)
        {
            NSIndexPath *selectedPath = itemArray.firstObject;
            TCClusterProvider *provider = [_providerArray objectAtIndex:selectedPath.row];
            NSString *regionName = [provider.regions objectAtIndex:indexPath.row];
            [cell setName:regionName];
        }
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = nil;
    if (collectionView == _providerView)
    {
        TCClusterProvider *provider = [_providerArray objectAtIndex:indexPath.row];
        text = provider.provider;
    }else if(collectionView == _areaView)
    {
        NSArray *itemArray = [_providerView indexPathsForSelectedItems];
        if (itemArray && itemArray.count > 0)
        {
            NSIndexPath *selectedPath = itemArray.firstObject;
            TCClusterProvider *provider = [_providerArray objectAtIndex:selectedPath.row];
            NSString *regionName = [provider.regions objectAtIndex:indexPath.row];
            text = regionName;
        }
    }
    else
    {
        text = @"阿里云";
    }
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TCFont(12.0)} context:nil].size;
    return CGSizeMake(textSize.width + 24, textSize.height + 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _providerView)
    {
        [_areaView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
