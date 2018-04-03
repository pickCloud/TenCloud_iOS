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

@interface TCAddAppViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint  *topConstraint;
@property (nonatomic, weak) IBOutlet    UIButton            *avatarButton;
@property (nonatomic, weak) IBOutlet    UIImageView         *avatarView;
@property (nonatomic, weak) IBOutlet    UITextField         *nameField;
@property (nonatomic, weak) IBOutlet    XXTextView          *descTextView;
@property (nonatomic, weak) IBOutlet    UICollectionView    *tagView;
@property (nonatomic, weak) IBOutlet    UIButton            *sourceButton;
- (IBAction) onAvatarButton:(id)sender;
- (IBAction) onMirrorSourceButton:(id)sender;
- (IBAction) onTagButton:(id)sender;
- (IBAction) onAddButton:(id)sender;
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
    TCAppBindRepoViewController *bindVC = [TCAppBindRepoViewController new];
    [self.navigationController pushViewController:bindVC animated:YES];
}

- (IBAction) onTagButton:(id)sender
{
    NSLog(@"on tag button");
    
}

- (IBAction) onAddButton:(id)sender
{
    
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

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
@end
