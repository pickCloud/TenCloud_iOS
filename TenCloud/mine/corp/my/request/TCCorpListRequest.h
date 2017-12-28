//
//  TCCorpListRequest.h
//  功能:获取公司列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

//@class TCClusterProvider;
@class TCListCorp;
@interface TCCorpListRequest : YTKRequest

//- (instancetype) initWithClusterID:(NSString*)clusterID;

- (void) startWithSuccess:(void(^)(NSArray<TCListCorp*> *corpArray))success
                  failure:(void(^)(NSString *message))failure;

@end
