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

- (void) uploadImage:(UIImage *)image success:(TCImageUploadSuccessBlock)successBlock
                fail:(TCImageUploadFailBlock)failBlock
{
    _successBlock = successBlock;
    _failBlock = failBlock;
    __weak __typeof(self) weakSelf = self;
    TCUploadTokenRequest *tokenReq = [TCUploadTokenRequest new];
    [tokenReq startWithSuccess:^(NSString *token) {
        QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
        QNUploadOption *opt =[[QNUploadOption alloc] initWithMime:@"jpg" progressHandler:nil params:nil checkCrc:YES cancellationSignal:nil];
        NSData *jpgData = UIImageJPEGRepresentation(image, 0.8);
        NSString *uuid = [NSString UUID];
        [uploadManager putData:jpgData key:uuid token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if (weakSelf.successBlock)
                          {
                              weakSelf.successBlock(key);
                          }
                      } option:opt];
    } failure:^(NSString *message) {
        if (weakSelf.failBlock)
        {
            weakSelf.failBlock(message);
        }
    }];
}
@end
