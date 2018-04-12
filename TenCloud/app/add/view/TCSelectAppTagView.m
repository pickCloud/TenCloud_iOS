//
//  TCSelectAppTagView.m
//  TenCloud
//
//  Created by huangdx on 2018/2/5.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCSelectAppTagView.h"
#import "UIView+TCAlertView.h"
#import "TCSelectTagLabelCell.h"
//#import "JYEqualCellSpaceFlowLayout.h"
#import "TCEditTag.h"
#import "TCEditTagCell.h"

#define SELECT_APP_TAG_CELL_ID      @"SELECT_APP_TAG_CELL_ID"
#define SELECT_APP_TAG_EDIT_CELL_ID @"SELECT_APP_TAG_EDIT_CELL_ID"

@interface TCSelectAppTagView()<UICollectionViewDelegate, UICollectionViewDataSource,
UITextFieldDelegate>
@property (nonatomic, strong)   NSMutableArray      *myTags;
@property (nonatomic, strong)   NSMutableArray      *editingTags;
@property (nonatomic, weak) IBOutlet    UIView              *editingView;
@property (nonatomic, weak) IBOutlet    UICollectionView    *editingTagView;
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *editingHeight;
@property (nonatomic, weak) IBOutlet    UICollectionView    *myTagView;
@property (nonatomic, strong) IBOutlet    UITextField         *tagTextField;
- (IBAction) onOkButton:(id)sender;
- (IBAction) textChangedAction:(id)sender;
- (void) updateTagTextFieldUI;
- (CGRect) tagTextFieldRect;
@end

@implementation TCSelectAppTagView

/*
- (id) init
{
    self = [super init];
    if (self)
    {
        _myTags = [NSMutableArray new];
        _resultTags = [NSMutableArray new];
        NSLog(@"ssselect app tag view1");
        
        NSArray *tags = @[@"web站",@"AI集群",@"视频存储专用",@"翻墙组",@"北美CDN",@"基础API"];
        [_myTags addObjectsFromArray:tags];
        
        UINib *cellNib = [UINib nibWithNibName:@"TCSelectTagLabelCell" bundle:nil];
        [_myTagView registerNib:cellNib forCellWithReuseIdentifier:SELECT_APP_TAG_CELL_ID];
        UICollectionViewFlowLayout *layout = nil;
        layout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:15.0];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [_myTagView setCollectionViewLayout:layout];
        _myTagView.dataSource = self;
        _myTagView.delegate = self;
    }
    return self;
}
 

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSLog(@"jjj2222");
    }
    return self;
}
*/

- (void) awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"jjjjjjjjj");
    _editingTags = [NSMutableArray new];
    TCEditTag *tag0 = [TCEditTag new];
    tag0.type = TCTagEditTypeNew;
    tag0.name = @"新增标签";
    [_editingTags addObject:tag0];
    _myTags = [NSMutableArray new];
    NSArray *tags = @[@"网站前端",@"AI集群",@"视频存储专用",@"翻墙组",@"北美CDN",@"基础API"];
    [_myTags addObjectsFromArray:tags];
    
    UINib *cellNib = [UINib nibWithNibName:@"TCSelectTagLabelCell" bundle:nil];
    [_myTagView registerNib:cellNib forCellWithReuseIdentifier:SELECT_APP_TAG_CELL_ID];
    UINib *editCellNib = [UINib nibWithNibName:@"TCEditTagCell" bundle:nil];
    [_editingTagView registerNib:editCellNib forCellWithReuseIdentifier:SELECT_APP_TAG_EDIT_CELL_ID];
    
    /*
    UICollectionViewFlowLayout *layout = nil;
    layout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:15.0];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_myTagView setCollectionViewLayout:layout];
     */
    _myTagView.dataSource = self;
    _myTagView.delegate = self;
    _editingTagView.dataSource = self;
    _editingTagView.delegate = self;
    
    self.tagTextField.delegate = self;
    
}

- (IBAction) onOkButton:(id)sender
{
    [self hideView];

    if (_resultBlock)
    {
        _resultBlock(self, @[]);
    }
}

- (IBAction) textChangedAction:(id)sender
{
    //NSLog(@"changed:%@",_testField.text);
}

- (void) updateTagTextFieldUI
{
    _tagTextField.frame = [self tagTextFieldRect];
}

- (CGRect) tagTextFieldRect
{
    NSInteger lastIndex = _editingTags.count - 1;
    NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
    UICollectionViewLayoutAttributes *attrs = [_editingTagView layoutAttributesForItemAtIndexPath:tmpPath];
    CGRect cellRect = attrs.frame;
    CGPoint editingTagViewOrigin = _editingTagView.frame.origin;
    CGRect lastRect = CGRectMake(cellRect.origin.x + editingTagViewOrigin.x + 4, cellRect.origin.y + editingTagViewOrigin.y, cellRect.size.width, cellRect.size.height);
    return lastRect;
}


#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _editingTagView)
    {
        return _editingTags.count;
    }
    return _myTags.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _editingTagView)
    {
        TCEditTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SELECT_APP_TAG_EDIT_CELL_ID forIndexPath:indexPath];
        TCEditTag *tag = [_editingTags objectAtIndex:indexPath.row];
        [cell setEditTag:tag];
        return cell;
    }
    TCSelectTagLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SELECT_APP_TAG_CELL_ID forIndexPath:indexPath];
    NSString *tagName = [_myTags objectAtIndex:indexPath.row];
    [cell setName:tagName];
    [cell setSelected:NO];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = nil;
    if (collectionView == _editingTagView)
    {
        TCEditTag *tag = [_editingTags objectAtIndex:indexPath.row];
        text =tag.name;
        BOOL isLastItem = indexPath.row == _editingTags.count - 1;
        BOOL isShortThan4 = text.length < 4;
        if ( isLastItem && isShortThan4 )
        {
            text = @"默认长度";
        }
    }else
    {
        text = [_myTags objectAtIndex:indexPath.row];
    }
    if (text == nil || text.length == 0)
    {
        text = @"默认长度";
    }
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TCFont(12.0)} context:nil].size;
    return CGSizeMake(textSize.width + 8, textSize.height + 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _myTagView)
    {
        NSString *selectedTagName = [_myTags objectAtIndex:indexPath.row];
        NSLog(@"selected tag name:%@",selectedTagName);
        TCEditTag *tag = [TCEditTag new];
        tag.type = TCTagEditTypeFinished;
        tag.name = selectedTagName;
        [_editingTags insertObject:tag atIndex:_editingTags.count - 1];
        //[_editingTags addObject:selectedTagName];
        [_editingTagView reloadData];
        CGFloat newHeight = _editingTagView.collectionViewLayout.collectionViewContentSize.height;
        _editingHeight.constant = newHeight;
    }else
    {
        TCEditTag *currentTag = [_editingTags objectAtIndex:indexPath.row];
        if (currentTag.type == TCTagEditTypeNew)
        {
            currentTag.type = TCTagEditTypeEditing;
            currentTag.name = @"";
            //TCEditTagCell *editingCell = (TCEditTagCell*)[_editingTagView cellForItemAtIndexPath:indexPath];
            //[editingCell setEditTag:currentTag];
            [_editingTagView reloadData];
            
            [self updateTagTextFieldUI];
            [_tagTextField becomeFirstResponder];
            NSLog(@"选中last cell");
        }else
        {
            NSLog(@"选中last cell2");
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *newTagName = textField.text;
    newTagName = [newTagName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (newTagName && newTagName.length > 0)
    {
        TCEditTag *tag = [TCEditTag new];
        tag.type = TCTagEditTypeFinished;
        tag.name = newTagName;
        [_editingTags insertObject:tag atIndex:_editingTags.count - 1];
    }
    TCEditTag *lastTag = _editingTags.lastObject;
    lastTag.name = @"";
    lastTag.type = TCTagEditTypeNew;
    [_editingTagView reloadData];
    CGFloat newHeight = _editingTagView.collectionViewLayout.collectionViewContentSize.height;
    _editingHeight.constant = newHeight;
    _tagTextField.text = @"";
    [self updateTagTextFieldUI];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length > 10)
    {
        [MBProgressHUD showError:@"标签长度需小于10" toView:nil];
        return NO;
    }
    NSLog(@"new str:%@",newString);
    //计算宽度,修改textField宽度
    UIFont *textFont = TCFont(10);
    NSDictionary *dictDict = @{NSFontAttributeName: textFont};
    CGSize textSize = [newString sizeWithAttributes:dictDict];
    CGSize minSize = [@"最小宽度" sizeWithAttributes:dictDict];
    NSLog(@"text size:%.2f",textSize.width);
    CGRect lastCellRect = [self tagTextFieldRect];
    lastCellRect.origin.x += 4;
    lastCellRect.size.width = textSize.width + 18;
    if (textSize.width < minSize.width)
    {
        lastCellRect.size.width = minSize.width + 18;
    }
    _tagTextField.frame = lastCellRect;
    
    TCEditTag *lastTag = _editingTags.lastObject;
    lastTag.name = newString;
    //should change here
    lastTag.type = TCTagEditTypeEditing;
    [_editingTagView reloadData];
    return YES;
}
@end
