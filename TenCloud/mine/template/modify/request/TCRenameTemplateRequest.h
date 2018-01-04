//
//  TCRenameTemplateRequest.h
//  功能:修改权限模版名称网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCRenameTemplateRequest : YTKRequest

- (instancetype) initWithTemplateID:(NSInteger)tid name:(NSString*)name;

- (void) startWithSuccess:(void(^)(NSString *message))success
                  failure:(void(^)(NSString *message))failure;

@end
