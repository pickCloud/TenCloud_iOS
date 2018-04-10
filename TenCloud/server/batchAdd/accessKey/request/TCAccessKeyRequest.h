//
//  TCAccessKeyRequest.h
//  功能:批量导入服务器第二步页面 验证云Access Key Secret
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCAccessKeyRequest : YTKRequest

@property (nonatomic, assign)   NSInteger   cloudID;
@property (nonatomic, strong)   NSString    *accessKey;
@property (nonatomic, strong)   NSString    *accessSecret;

- (void) startWithSuccess:(void(^)(NSString *status))success
                  failure:(void(^)(NSString *message))failure;

@end
