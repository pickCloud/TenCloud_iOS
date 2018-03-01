//
//  TCEditAvatarTableViewCell.m
//  TenCloud
//
//  Created by huangdx on 2017/12/25.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCEditAvatarTableViewCell.h"
#import "TCCellData.h"
#import "LSActionSheet.h"
#import "UIImage+Resizing.h"
#import "TCUploadTokenRequest.h"
#import <Qiniu/QiniuSDK.h>
#import "NSString+Extension.h"
#import "TCModifyUserProfileRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TCUserProfileRequest.h"
#import "TCUser+CoreDataClass.h"
#import "TCModifyCorpProfileRequest.h"
#import "TCCorpProfileRequest.h"
#import "TCCorp+CoreDataClass.h"

@interface  TCEditAvatarTableViewCell()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet    NSLayoutConstraint      *trailingConstraint;
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

- (void) setData:(TCCellData *)data
{
    [super setData:data];
    self.nameLabel.text = data.title;
    self.descLabel.text = data.initialValue;
    NSURL *avatarURL = [NSURL URLWithString:data.initialValue];
    UIImage *defaultAvatarImg = [UIImage imageNamed:@"default_avatar"];
    [self.avatarView sd_setImageWithURL:avatarURL placeholderImage:defaultAvatarImg];
    if (self.data.editable)
    {
        [self.detailView setHidden:NO];
        _trailingConstraint.constant = 12;
    }else
    {
        [self.detailView setHidden:YES];
        _trailingConstraint.constant = -6;
    }
}

- (IBAction) onButton:(id)sender
{
    if (!self.data.editable)
    {
        return;
    }
    NSArray *menuArray = [NSArray arrayWithObjects:@"相册",@"相机", nil];
    [LSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:menuArray block:^(int index) {
        switch (index) {
            case 0:
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = YES;//设置可编辑
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
    __weak __typeof(self) weakSelf = self;
    [MMProgressHUD showWithStatus:@"修改头像中"];
    TCUploadTokenRequest *tokenReq = [TCUploadTokenRequest new];
    [tokenReq startWithSuccess:^(NSString *token) {
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        QNUploadOption *opt =[[QNUploadOption alloc] initWithMime:@"jpg" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
        NSData *jpgData = UIImageJPEGRepresentation(avatarImage, 0.8);
        NSString *uuid = [NSString UUID];
        [uploadManager putData:jpgData key:uuid token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if (self.data.apiType == TCApiTypeDefault)
                          {
                              TCModifyUserProfileRequest *modifyReq = [[TCModifyUserProfileRequest alloc] initWithKey:@"image_url" value:key];
                              [modifyReq startWithSuccess:^(NSString *message) {
                                  TCUserProfileRequest *userReq = [TCUserProfileRequest new];
                                  [userReq startWithSuccess:^(TCUser *user) {
                                      TCLocalAccount *account = [TCLocalAccount shared];
                                      account.avatar = user.image_url;
                                      [account save];
                                      [account modified];
                                      [weakSelf.avatarView setImage:avatarImage];
                                      [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
                                  } failure:^(NSString *message) {
                                      [MMProgressHUD dismissWithError:message];
                                  }];
                              } failure:^(NSString *message) {
                                  [MMProgressHUD dismissWithError:message];
                              }];
                          }else if(self.data.apiType == TCApiTypeUpdateCorp)
                          {
                              TCCurrentCorp *corp = [TCCurrentCorp shared];
                              TCModifyCorpProfileRequest *modifyReq = [[TCModifyCorpProfileRequest alloc] initWithCid:corp.cid key:@"image_url" value:key];
                              [modifyReq startWithSuccess:^(NSString *message) {
                                  TCCorpProfileRequest *corpReq = [[TCCorpProfileRequest alloc] initWithCorpID:corp.cid];
                                  [corpReq startWithSuccess:^(TCCorp *corp) {
                                      [[TCCurrentCorp shared] setImage_url:corp.image_url];
                                      [[TCCurrentCorp shared] modified];
                                      [weakSelf.avatarView setImage:avatarImage];
                                      [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:1.32];
                                  } failure:^(NSString *message) {
                                      [MMProgressHUD dismissWithError:message];
                                  }];

                              } failure:^(NSString *message) {
                                  [MMProgressHUD dismissWithError:message];
                              }];
                          }
                      } option:opt];
    } failure:^(NSString *message) {
        [MMProgressHUD dismissWithError:message];
    }];
}

@end
