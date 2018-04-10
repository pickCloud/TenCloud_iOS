//
//  TCAddAppViewController.m
//  TenCloud
//
//  Created by huangdx on 2018/4/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCAddAppViewController.h"
#import "XXTextView.h"
#import "TCImageUploader.h"
#import "LSActionSheet.h"
#import "UIImage+Resizing.h"
#import "TCAppBindRepoViewController.h"
#import "TCGitRepo.h"
#import "TCTagLabelCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
#import "TCSelectAppTagView.h"
#import "TCAlertController.h"
#import "UIView+TCAlertView.h"
#import "TCAddAppRequest.h"

#define ADD_APP_TAG_CELL_ID @"ADD_APP_TAG_CELL_ID"

@interface TCAddAppViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UIButton            *avatarButton;
@property (nonatomic, weak) IBOutlet    UIImageView         *avatarView;
@property (nonatomic, weak) IBOutlet    UITextField         *nameField;
@property (nonatomic, weak) IBOutlet    XXTextView          *descTextView;
@property (nonatomic, weak) IBOutlet    UICollectionView    *tagView;
@property (nonatomic, weak) IBOutlet    UILabel             *editTagLabel;
@property (nonatomic, weak) IBOutlet    UIButton            *sourceButton;
@property (nonatomic, strong)   NSString                    *repoName;
@property (nonatomic, strong)   NSString                    *repoAddress;
@property (nonatomic, strong)   NSString                    *logoURLStr;
@property (nonatomic, strong)   NSMutableArray              *tagArray;
- (IBAction) onAvatarButton:(id)sender;
- (IBAction) onMirrorSourceButton:(id)sender;
- (IBAction) onTagButton:(id)sender;
- (IBAction) onAddButton:(id)sender;
- (void) updateTagUI;
@end

@implementation TCAddAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加应用";
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.descTextView.xx_placeholder = @"请输入应用的描述";
    self.descTextView.xx_placeholderColor = THEME_PLACEHOLDER_COLOR;
    /*
    if (IS_iPhoneX)
    {
        _topConstraint.constant = 64+27;
    }
     */
    _tagArray = [NSMutableArray new];
    /*
    [_tagArray addObject:@"web站"];
    [_tagArray addObject:@"AI集群"];
    [_tagArray addObject:@"视频存储专用"];
    [_tagArray addObject:@"翻墙组"];
    [_tagArray addObject:@"北美CDN"];
    [_tagArray addObject:@"基础API"];
     */
    
    UINib *tagCellNib = [UINib nibWithNibName:@"TCTagLabelCell" bundle:nil];
    [_tagView registerNib:tagCellNib forCellWithReuseIdentifier:ADD_APP_TAG_CELL_ID];
    UICollectionViewFlowLayout *layout = nil;
    layout = [[JYEqualCellSpaceFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:8.0];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [_tagView setCollectionViewLayout:layout];
    
    [self updateTagUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - extension
- (IBAction) onAvatarButton:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    NSArray *menus = @[@"相册",@"相机"];
    [LSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:menus block:^(int index) {
        if (index == 2)
        {
            return ;
        }
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.delegate = weakSelf;
        picker.allowsEditing = YES;
        if (index == 0)
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [weakSelf presentViewController:picker animated:YES completion:nil];
    }];
    
}

- (IBAction) onMirrorSourceButton:(id)sender
{
    __weak __typeof(self) weakSelf = self;
    TCAppBindRepoViewController *bindVC = [TCAppBindRepoViewController new];
    bindVC.bindBlock = ^(TCGitRepo *repo) {
        if ([repo isValid])
        {
            weakSelf.repoName = repo.name;
            weakSelf.repoAddress = repo.address;
            [weakSelf.sourceButton setTitle:repo.name forState:UIControlStateNormal];
        }else
        {
            [weakSelf.sourceButton setTitle:@"绑定github代码仓库" forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (IBAction) onTagButton:(id)sender
{
    NSLog(@"on tag button");
    TCSelectAppTagView *view = [TCSelectAppTagView createViewFromNib];
    TCAlertController *ctrl = [[TCAlertController alloc] initWithAlertView:view
    preferredStyle:TCAlertControllerStyleAlert transitionAnimation:TCAlertTransitionAnimationFade transitionAnimationClass:nil];
    ctrl.backgoundTapDismissEnable = NO;
    [ctrl present];
    
}

- (IBAction) onAddButton:(id)sender
{
    if (_nameField.text.length <= 0)
    {
        [MBProgressHUD showError:@"名称不能为空" toView:nil];
        return;
    }
    if ([_nameField isFirstResponder])
    {
        [_nameField resignFirstResponder];
    }
    if (_descTextView.text.length <= 0)
    {
        [MBProgressHUD showError:@"描述不能为空" toView:nil];
        return;
    }
    if ([_descTextView isFirstResponder])
    {
        [_descTextView resignFirstResponder];
    }
    
    __weak __typeof(self) weakSelf = self;
    TCAddAppRequest *req = [TCAddAppRequest new];
    req.name = _nameField.text;
    req.desc = _descTextView.text;
    req.repos_name = _descTextView.text;
    req.repos_https_url = _repoAddress;
    req.logo_url = _logoURLStr;
    req.image_id = @(0);
    [req startWithSuccess:^(NSInteger appID) {
        NSLog(@"ok app id:%ld",appID);
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:@"成功创建应用" toView:nil];
    } failure:^(NSString *message) {
        [TCAlertController presentWithTitle:message okBlock:nil];
    }];
}

- (void) updateTagUI
{
    if (_tagArray.count > 0)
    {
        _editTagLabel.hidden = YES;
    }else
    {
        _editTagLabel.hidden = NO;
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //__weak __typeof(self) weakSelf = self;
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *avatarImage = [editedImage scaleToSize:CGSizeMake(400, 400)];
    [self setNewAvatarWithImage:avatarImage];
    //[weakSelf setNewAvatarWithImage:avatarImage];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) setNewAvatarWithImage:(UIImage*)avatarImage
{
    NSLog(@"准备上传");
    __weak __typeof(self) weakSelf = self;
    TCImageUploader *uploader = [TCImageUploader new];
    uploader.successBlock = ^(NSString *key) {
        [weakSelf.avatarButton setImage:avatarImage forState:UIControlStateNormal];
        //NSString *prefix = @"http://ou3t8uyol.bkt.clouddn.com/";
        //NSString *urlStr = [NSString stringWithFormat:@"%@%@",prefix,key];
        weakSelf.logoURLStr = key;//urlStr;
    };
    uploader.failBlock = ^(NSString *message) {
        NSLog(@"上传失败:%@",message);
    };
    [uploader uploadImage:avatarImage];
    /*
    [uploader uploadImage:avatarImage success:^(NSString *key) {
        NSLog(@"上传成功:%@",key);
        [weakSelf.avatarButton setImage:avatarImage forState:UIControlStateNormal];
    } fail:^(NSString *message) {
        NSLog(@"上传失败:%@",message);
    }];
     */
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tagArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCTagLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ADD_APP_TAG_CELL_ID forIndexPath:indexPath];
    NSString *tagName = [_tagArray objectAtIndex:indexPath.row];
    [cell setName:tagName];
    [cell setSelected:NO];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [_tagArray objectAtIndex:indexPath.row];
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
