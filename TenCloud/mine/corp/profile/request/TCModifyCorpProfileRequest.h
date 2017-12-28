//
//  TCModifyCorpProfileRequest.h
//  功能:修改企业资料的网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServer;
@interface TCModifyCorpProfileRequest : YTKRequest

- (instancetype) initWithCid:(NSInteger)cid key:(NSString*)keyName value:(id)value;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
