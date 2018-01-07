//
//  TCEmptyPermissionRequest.h
//  功能:获取权限模版详细配置数据
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

//@class TCPermissionSegment;
@class TCPermissionNode;
@interface TCEmptyPermissionRequest : YTKRequest

- (instancetype) initWithCorpID:(NSInteger)cid;

- (void) startWithSuccess:(void(^)(NSArray<TCPermissionNode *> *nodeArray))success
                  failure:(void(^)(NSString *message))failure;

@end
