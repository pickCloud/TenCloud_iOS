//
//  TCTagListRequest.h
//  功能:获取标签列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCEditTag;
@interface TCTagListRequest : YTKRequest

- (NSArray<TCEditTag*> *)resultTagArray;

- (void) startWithSuccess:(void(^)(NSArray<TCEditTag*> *tagArray))success
                  failure:(void(^)(NSString *message))failure;

@end
