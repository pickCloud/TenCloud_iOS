//
//  TCAddCorpRequest.h
//  功能:添加企业网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCAddCorpRequest : YTKRequest

- (instancetype) initWithName:(NSString *)name contact:(NSString *)contact
                      phone:(NSString *)phone;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
