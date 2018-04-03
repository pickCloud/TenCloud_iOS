//
//  TCImageUploader.h
//  TenCloud
//
//  Created by huangdx on 2018/4/2.
//  Copyright © 2018年 10.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TCImageUploadSuccessBlock)(NSString *key);
typedef void (^TCImageUploadFailBlock)(NSString *message);

@interface TCImageUploader : NSObject

@property (nonatomic, copy) TCImageUploadSuccessBlock   successBlock;
@property (nonatomic, copy) TCImageUploadFailBlock      failBlock;

- (void) uploadImage:(UIImage *)image;

//- (void) uploadImage:(UIImage *)image success:(TCImageUploadSuccessBlock)successBlock
//                fail:(TCImageUploadFailBlock)failBlock;

@end
