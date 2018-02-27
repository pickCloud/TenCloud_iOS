//
//  TCClusterRequest.h
//  功能:获取服务器列表,此接口目前不再使用
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServer;
@interface TCClusterRequest : YTKRequest

- (void) startWithSuccess:(void(^)(NSArray<TCServer*> *serverArray))success
                  failure:(void(^)(NSString *message))failure;

@end
