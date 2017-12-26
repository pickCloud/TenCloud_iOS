//
//  TCUploadTokenRequest.h
//  功能:获取上传文件所需token
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCUploadTokenRequest : YTKRequest

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message))failure;

@end
