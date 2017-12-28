//
//  TCCorpProfileRequest.h
//  功能:获取企业信息
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCCorp;
@interface TCCorpProfileRequest : YTKRequest

- (instancetype) initWithCorpID:(NSInteger)cid;

- (void) startWithSuccess:(void(^)(TCCorp *corp))success
                  failure:(void(^)(NSString *message))failure;

@end
