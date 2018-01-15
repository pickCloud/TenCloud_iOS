//
//  TCCompleteInviteRequest.h
//  功能:完成邀请请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCCompleteInviteRequest : YTKRequest

@property (nonatomic, strong)   NSString    *code;
@property (nonatomic, strong)   NSString    *mobile;
@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSString    *idCard;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
