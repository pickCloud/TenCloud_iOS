//
//  TCAppRequest.h
//  功能:获取应用信息
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCApp;
@interface TCAppRequest : YTKRequest

@property (nonatomic, assign)   NSInteger   appID;

- (void) startWithSuccess:(void(^)(TCApp *app))success
                  failure:(void(^)(NSString *message))failure;

@end
