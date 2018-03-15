//
//  TCServerHomeUsageCell.m
//  TenCloud
//
//  Created by huangdx on 2018/3/14.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCServerHomeUsageCell.h"
#import "TCServerUsageCollectionCell.h"
#import "TCServerUsage1Cell.h"
#import "TCServerUsage2Cell.h"
#import "TCServerUsage3Cell.h"
#import "TCServerUsage4Cell.h"
#import "TCServerProfileViewController.h"
#import "TCServerUsage+CoreDataClass.h"

#define SERVER_USAGE_CELL_REUSE_ID      @"SERVER_USAGE_CELL_REUSE_ID"
#define SERVER_USAGE_CELL1_ID           @"SERVER_USAGE_CELL1_ID"
#define SERVER_USAGE_CELL2_ID           @"SERVER_USAGE_CELL2_ID"
#define SERVER_USAGE_CELL3_ID           @"SERVER_USAGE_CELL3_ID"
#define SERVER_USAGE_CELL4_ID           @"SERVER_USAGE_CELL4_ID"
@interface TCServerHomeUsageCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, assign)   NSInteger           columnAmount;
@property (nonatomic, weak) IBOutlet    UILabel     *cpuUsageLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *memoryUsageLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *diskIOLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *diskUsageLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *networkIOLabel;
@property (nonatomic, weak) IBOutlet    UICollectionView    *collectionView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *collectionViewHeightConstraint;
@property (nonatomic, strong)   NSArray<TCServerUsage*>     *usageArray;
@end

@implementation TCServerHomeUsageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    UINib *cellNib = [UINib nibWithNibName:@"TCServerUsageCollectionCell" bundle:nil];
    [self.collectionView registerNib:cellNib
          forCellWithReuseIdentifier:SERVER_USAGE_CELL_REUSE_ID];
    UINib *cell1Nib = [UINib nibWithNibName:@"TCServerUsage1Cell" bundle:nil];
    [self.collectionView registerNib:cell1Nib forCellWithReuseIdentifier:SERVER_USAGE_CELL1_ID];
    UINib *cell2Nib = [UINib nibWithNibName:@"TCServerUsage2Cell" bundle:nil];
    [self.collectionView registerNib:cell2Nib forCellWithReuseIdentifier:SERVER_USAGE_CELL2_ID];
    UINib *cell3Nib = [UINib nibWithNibName:@"TCServerUsage3Cell" bundle:nil];
    [self.collectionView registerNib:cell3Nib forCellWithReuseIdentifier:SERVER_USAGE_CELL3_ID];
    UINib *cell4Nib = [UINib nibWithNibName:@"TCServerUsage4Cell" bundle:nil];
    [self.collectionView registerNib:cell4Nib forCellWithReuseIdentifier:SERVER_USAGE_CELL4_ID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUsageData:(NSArray<TCServerUsage*> *)usageArray
{
    _usageArray = usageArray;
    
    //NSInteger columnAmount = 1;
    _columnAmount = 1;
    if (_usageArray.count >= 2 && _usageArray.count <= 4)
    {
        _columnAmount = 2;
    }else if(_usageArray.count >= 5 && _usageArray.count <= 9)
    {
        _columnAmount = 3;
    }else if(_usageArray.count >= 10)
    {
        _columnAmount = 4;
    }
    
    CGFloat width = TCSCALE(345);
    CGFloat interval = 1.0;
    CGFloat rowWidth = (width - (_columnAmount - 1)*interval - 1)/_columnAmount;
    CGFloat rowHeight = rowWidth * 0.7347;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGSize itemSize = CGSizeMake(rowWidth, rowHeight);
    layout.itemSize = itemSize;
    layout.minimumInteritemSpacing = interval;
    layout.minimumLineSpacing = interval;
    [_collectionView setCollectionViewLayout:layout];
    
    NSInteger rowAmount = ceil(_usageArray.count * 1.0 / _columnAmount);
    CGFloat newHeight = rowAmount * rowHeight + (rowAmount - 1)*interval;
    _collectionViewHeightConstraint.constant = newHeight;
    NSLog(@"rowAmount:%ld",rowAmount);
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCServerUsageCollectionCell *cell = (TCServerUsageCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //[cell setBackgroundColor:[UIColor redColor]];
    [cell highlight];
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCServerUsageCollectionCell *cell = (TCServerUsageCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    //[cell setBackgroundColor:[UIColor yellowColor]];
    [cell unhighlight];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item at %ld",indexPath.row);
    TCServerUsage *usage = [_usageArray objectAtIndex:indexPath.row];
    TCServerProfileViewController *profileVC = [[TCServerProfileViewController alloc] initWithID:usage.serverID];
    [_navController pushViewController:profileVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"server home usage cell count:%ld",_usageArray.count);
    return _usageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCServerUsageCollectionCell *cell = nil;
    if (_columnAmount == 1)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SERVER_USAGE_CELL1_ID
                                                         forIndexPath:indexPath];
    }else if(_columnAmount == 2)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SERVER_USAGE_CELL2_ID
                                                         forIndexPath:indexPath];
    }else if(_columnAmount == 3)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SERVER_USAGE_CELL3_ID
                                                         forIndexPath:indexPath];
    }else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:SERVER_USAGE_CELL4_ID
                                                         forIndexPath:indexPath];
    }
    TCServerUsage *usage = [_usageArray objectAtIndex:indexPath.row];
    [cell setUsage:usage];
    return cell;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    NSLog(@"hit test at home usage cell:%.2f,%.2f",point.x, point.y);
//    UIView *view = [super hitTest:point withEvent:event];
//    if (![view isKindOfClass:[UICollectionView class]]) {
//        return self;
//    }else if(![view isKindOfClass:[UICollectionViewCell class]])
//    {
//        return self;
//    }
//    return [super hitTest:point withEvent:event];
//}

/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"hit test at home usage cell:%.2f,%.2f",point.x, point.y);
    UIView *view = [super hitTest:point withEvent:event];
    return [super hitTest:point withEvent:event];
}
 */

@end
