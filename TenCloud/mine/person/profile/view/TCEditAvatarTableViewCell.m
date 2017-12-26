//
//  TCEditAvatarTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditAvatarTableViewCell.h"
#import "TCEditCellData.h"
#import "LSActionSheet.h"
#import "UIImage+Resizing.h"
#import "VHLNavigation.h"
#import "TCUploadTokenRequest.h"
#import <Qiniu/QiniuSDK.h>
#import "NSString+Extension.h"
#import "TCModifyUserProfileRequest.h"

@interface TCEditAvatarTableViewCell()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet    UIImageView     *avatarView;
- (IBAction) onButton:(id)sender;
@end

@implementation TCEditAvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(TCEditCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    self.descLabel.text = data.initialValue;
}

- (IBAction) onButton:(id)sender
{
    NSLog(@"avatar button");
    NSArray *menuArray = [NSArray arrayWithObjects:@"相册",@"相机", nil];
    [LSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:menuArray block:^(int index) {
        switch (index) {
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = YES;//设置可编辑
                //picker.navigationBar.barStyle = UIBarStyleBlack;
                
                if ([picker.navigationBar respondsToSelector:@selector(setBarTintColor:)])
                {
                    [picker.navigationBar setTranslucent:NO];
                    [picker.navigationBar setBarTintColor:[UIColor purpleColor]];
                    [picker.navigationBar setTintColor:[UIColor blueColor]];
                    NSLog(@"condition111");
                }else
                {
                    [picker.navigationBar setBackgroundColor:[UIColor blackColor]];
                    NSLog(@"condition222");
                }
                
                //[picker vhl_setNavBackgroundColor:[UIColor purpleColor]];
                //[picker vhl_setNavBarTintColor:[UIColor redColor]];
                //[picker vhl_setNavBarTitleColor:[UIColor greenColor]];
                
                /*
                //仅第一个导航栏有效，且有极大的崩溃风险，不建议采用
                [self.fatherViewController presentViewController:picker animated:YES completion:^{
                    UIViewController *controller = picker.viewControllers.lastObject;
                    UIBarButtonItem *cancelButton = [controller valueForKey:@"imagePickerCancelButton"];
                    if (cancelButton)
                    {
                        UIButton *button = [cancelButton valueForKey:@"view"];
                        if (button)
                        {
                            [button setTitleColor:THEME_NAVBAR_TITLE_COLOR forState:UIControlStateNormal];
                        }
                    }
                }];
                */
                [self.fatherViewController presentViewController:picker animated:YES completion:nil];
            }
                break;
            case 1:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;//设置可编辑
                picker.showsCameraControls = YES;
                //picker.navigationBarHidden = YES;
                //[picker setNavigationBarHidden:YES];
                //[self vhl_setNavBarHidden:YES];
                
                //[picker vhl_setNavBarHidden:YES];
                //[self presentViewController:picker animated:YES completion:nil];//进入照相界面
                [self.fatherViewController presentViewController:picker animated:YES completion:nil];
            }
                break;
        }
    }];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *avatarImage = [editedImage scaleToSize:CGSizeMake(400, 400)];
        [weakSelf setNewAvatarWithImage:avatarImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) setNewAvatarWithImage:(UIImage*)avatarImage
{
    TCUploadTokenRequest *tokenReq = [TCUploadTokenRequest new];
    [tokenReq startWithSuccess:^(NSString *token) {
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        QNUploadOption *opt =[[QNUploadOption alloc] initWithMime:@"jpg" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
        NSData *jpgData = UIImageJPEGRepresentation(avatarImage, 0.8);
        NSString *uuid = [NSString UUID];
        [uploadManager putData:jpgData key:uuid token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          //NSString *imgURLStr = [NSString stringWithFormat:@"%@%@",token.url,key];
                          __weak __typeof(self) weakSelf = self;
                          TCModifyUserProfileRequest *modifyReq = [[TCModifyUserProfileRequest alloc] initWithKey:@"image_url" value:key];
                          [modifyReq startWithSuccess:^(NSString *message) {
                              NSLog(@"message:%@",message);
                          } failure:^(NSString *message) {
                              [MBProgressHUD showError:message toView:nil];
                          }];
                          
                      } option:opt];
    } failure:^(NSString *message) {
        
    }];
}

@end
