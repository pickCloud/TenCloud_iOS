//
//  TCJoinSettingRequest.h
//  功能:获取加入配置列表
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "YTKRequest.h"

@interface TCJoinSettingRequest : YTKRequest

- (void) startWithSuccess:(void(^)(NSArray<NSString*> *settingArray))success
                  failure:(void(^)(NSString *message))failure;

@end
