//
//  TCSearchMessageRequest.h
//  功能:搜索消息
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@class TCMessage;
@interface TCSearchMessageRequest : YTKRequest

@property (nonatomic, assign)   NSInteger   status;
@property (nonatomic, assign)   NSInteger   mode;
@property (nonatomic, strong)   NSString    *keywords;

- (void) startWithSuccess:(void(^)(NSArray<TCMessage*> *messageArray))success
                  failure:(void(^)(NSString *message))failure;

@end
