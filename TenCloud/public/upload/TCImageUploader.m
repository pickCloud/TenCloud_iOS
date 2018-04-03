//
//  TCImageUploader.m
//  TenCloud
//
//  Created by huangdx on 2018/4/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import "TCImageUploader.h"
#import "TCUploadTokenRequest.h"
#import <Qiniu/QiniuSDK.h>
#import "NSString+Extension.h"

@implementation TCImageUploader

- (void) uploadImage:(UIImage *)image
{
    __weak __typeof(self) weakSelf = self;
    TCUploadTokenRequest *tokenReq = [TCUploadTokenRequest new];
    [tokenReq startWithSuccess:^(NSString *token) {
        //__strong __typeof(weakSelf) strongSelf = weakSelf;
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        QNUploadOption *opt =[[QNUploadOption alloc] initWithMime:@"jpg" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
        NSData *jpgData = UIImageJPEGRepresentation(image, 0.8);
        NSString *uuid = [NSString UUID];
        [uploadManager putData:jpgData key:uuid token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          //NSLog(@"successBlock2:%@",weakSelf.successBlock);
                          //NSLog(@"传输结束：key %@",key);
                          /*
                          if (strongSelf.successBlock)
                          {
                              strongSelf.successBlock(key);
                          }
                           */
                          if (self.successBlock)
                          {
                              self.successBlock(key);
                          }
                      } option:opt];
    } failure:^(NSString *message) {
        NSLog(@"获取token失败:%@",message);
        if (weakSelf.failBlock)
        {
            weakSelf.failBlock(message);
        }
    }];
}

/*
- (void) uploadFinished:(NSString*)key
{
    NSLog(@"_ss:%@",_successBlock);
    if (_successBlock)
    {
        _successBlock(key);
    }
}

- (void) uploadFailed:(NSString*)message
{
    NSLog(@"_ff:%@",_failBlock);
    if (_failBlock)
    {
        _failBlock(message);
    }
}

- (void) uploadImage:(UIImage *)image success:(TCImageUploadSuccessBlock)successBlock
                fail:(TCImageUploadFailBlock)failBlock
{
    //_successBlock = successBlock;
    //_failBlock = failBlock;
    __weak __typeof(self) weakSelf = self;
    TCUploadTokenRequest *tokenReq = [TCUploadTokenRequest new];
    [tokenReq startWithSuccess:^(NSString *token) {
        NSLog(@"获得图片token:%@",token);
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        QNUploadOption *opt =[[QNUploadOption alloc] initWithMime:@"jpg" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
        NSData *jpgData = UIImageJPEGRepresentation(image, 0.8);
        NSString *uuid = [NSString UUID];
        [uploadManager putData:jpgData key:uuid token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSLog(@"successBlock:%@",weakSelf.successBlock);
                          NSLog(@"传输结束：key %@",key);
                          if (weakSelf.successBlock)
                          {
                              weakSelf.successBlock(key);
                          }
                      } option:opt];
    } failure:^(NSString *message) {
        NSLog(@"获取token失败:%@",message);
        if (weakSelf.failBlock)
        {
            weakSelf.failBlock(message);
        }
    }];
}
 */
@end
