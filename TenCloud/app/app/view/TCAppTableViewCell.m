//
//  TCAppTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCAppTableViewCell.h"
#import "TCApp+CoreDataClass.h"
#import "TCProgressView.h"
#import "NSString+Extension.h"
#import "TCTagLabelCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "TCAppStatusLabel.h"

#define APP_TAG_CELL_ID     @"APP_TAG_CELL_ID"

@interface TCAppTableViewCell ()
@property (nonatomic, strong)   TCApp               *app;
@property (nonatomic, weak) IBOutlet    UILabel     *nameLabel;
@property (nonatomic, weak) IBOutlet    UIView      *bgView;
@property (nonatomic, weak) IBOutlet    UIView      *avatarView;
@property (nonatomic, weak) IBOutlet    UILabel     *sourceLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *createTimeLabel;
@property (nonatomic, weak) IBOutlet    UILabel     *updateTimeLabel;
@property (nonatomic, weak) IBOutlet    TCAppStatusLabel    *statusLabel;
@property (nonatomic, weak) IBOutlet    UICollectionView    *labelCollectionView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *labelHeight;
- (void) updateUI;
@end

@implementation TCAppTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.00];
    self.selectedBackgroundView = selectedBgView;
    
    self.bgView.layer.cornerRadius = TCSCALE(2.0);
    
    UINib *labelCellNib = [UINib nibWithNibName:@"TCTagLabelCell" bundle:nil];
    [_labelCollectionView registerNib:labelCellNib forCellWithReuseIdentifier:APP_TAG_CELL_ID];
    UICollectionViewFlowLayout *layout = nil;
    layout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:8.0];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_labelCollectionView setCollectionViewLayout:layout];
    //[_labelCollectionView setAllowsMultipleSelection:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    [self updateUI];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateUI];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    //[self updateUI];
}

- (void) setApp:(TCApp*)app
{
    _app = app;
    _nameLabel.text = app.name;
    _sourceLabel.text = app.source;
    //_createTimeLabel.text = [NSString timeStringFromInteger:app.createTime];
    _createTimeLabel.text = [NSString dateTimeStringFromTimeInterval:app.createTime];
    [_statusLabel setStatus:app.status];
    [_labelCollectionView reloadData];
}

- (void) updateUI
{
    if (self.highlighted)
    {
        self.bgView.backgroundColor = THEME_NAVBAR_TITLE_COLOR;
    }else
    {
        self.bgView.backgroundColor = TABLE_CELL_BG_COLOR;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}


#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _app.labels.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCTagLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:APP_TAG_CELL_ID forIndexPath:indexPath];
    NSString *tagName = [_app.labels objectAtIndex:indexPath.row];
    [cell setName:tagName];
    [cell setSelected:NO];
    return cell;
    /*
    TCTimePeriodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SERVER_PROFILE_PERIOD_CELL_ID forIndexPath:indexPath];
    NSString *periodName = [_periodMenuOptions objectAtIndex:indexPath.row];
    [cell setName:periodName];
    [cell setSelected:indexPath.row == _periodSelectedIndex];
    return cell;
     */
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [_app.labels objectAtIndex:indexPath.row];
    //NSString *text = [_periodMenuOptions objectAtIndex:indexPath.row];
    if (text == nil || text.length == 0)
    {
        text = @"默认";
    }
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TCFont(10.0)} context:nil].size;
    return CGSizeMake(textSize.width + 6, textSize.height + 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
