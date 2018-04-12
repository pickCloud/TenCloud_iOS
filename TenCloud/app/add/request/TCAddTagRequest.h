//
//  TCAddTagRequest.h
//  功能:添加标签网络请求
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCAddTagRequest : YTKRequest

@property (nonatomic, strong)   NSString    *name;
//@property (nonatomic, strong)   NSNumber    *type;

- (void) startWithSuccess:(void(^)(NSInteger tagID))success
                  failure:(void(^)(NSString *message))failure;

@end
