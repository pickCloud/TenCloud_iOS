//
//  TCServerSummaryRequest.h
//  功能:获取服务器首页概况
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCServerSummary;
@interface TCServerSummaryRequest : YTKRequest

- (void) startWithSuccess:(void(^)(TCServerSummary *summary))success
                  failure:(void(^)(NSString *message))failure;

@end
