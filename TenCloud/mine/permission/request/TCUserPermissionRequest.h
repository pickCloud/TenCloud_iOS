//
//  TCUserPermissionRequest.h
//  功能:获取用户权限详细配置数据
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

//@class TCPermissionNode;
@class TCTemplate;
@interface TCUserPermissionRequest : YTKRequest

@property (nonatomic, assign)   NSInteger     corpID;
@property (nonatomic, assign)   NSInteger     userID;
//- (instancetype) initWithCorpID:(NSInteger)cid userID:(NSInteger)uid;
@property (nonatomic, strong)   TCTemplate      *resultTemplate;

- (TCTemplate *) resultTemplate;

- (void) startWithSuccess:(void(^)(TCTemplate *tmpl))success
                  failure:(void(^)(NSString *message))failure;

@end
