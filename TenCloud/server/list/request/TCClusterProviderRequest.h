//
//  TCClusterProviderRequest.h
//  功能:获取服务商数据列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCClusterProvider;
@interface TCClusterProviderRequest : YTKRequest

- (instancetype) initWithClusterID:(NSString*)clusterID;

- (void) startWithSuccess:(void(^)(NSArray<TCClusterProvider*> *providerArray))success
                  failure:(void(^)(NSString *message))failure;

@end