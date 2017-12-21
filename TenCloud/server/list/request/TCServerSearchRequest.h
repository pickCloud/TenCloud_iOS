//
//  TCServerSearchRequest.h
//  功能:服务器搜索请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServer;
@interface TCServerSearchRequest : YTKRequest

- (instancetype) initWithServerName:(NSString*)name
                            regions:(NSArray*)regions
                          providers:(NSArray*)providers;

- (void) startWithSuccess:(void(^)(NSArray<TCServer*> *serverArray))success
                  failure:(void(^)(NSString *message))failure;

@end
